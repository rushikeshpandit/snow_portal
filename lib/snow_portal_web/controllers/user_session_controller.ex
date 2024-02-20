defmodule SnowPortalWeb.UserSessionController do
  use SnowPortalWeb, :controller

  alias SnowPortal.Accounts
  alias SnowPortalWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"login_as" => login_as, "password" => password} = user_params

    case login_as do
      "username" ->
        %{"user_name" => user_name} = user_params

        if user = Accounts.get_user_by_username_and_password(user_name, password) do
          handle_success(conn, info, user, user_params)
        else
          handle_error(conn, login_as, user_name)
        end

      _ ->
        %{"email" => email} = user_params

        if user = Accounts.get_user_by_email_and_password(email, password) do
          handle_success(conn, info, user, user_params)
        else
          handle_error(conn, login_as, email)
        end
    end
  end

  defp handle_success(conn, info, user, user_params) do
    conn
    |> put_flash(:info, info)
    |> UserAuth.log_in_user(user, user_params)
  end

  defp handle_error(conn, login_as, value) do
    # In order to prevent user enumeration attacks,
    # don't disclose whether the email / username is registered.
    message =
      (login_as == "username" && "Invalid username or password") || "Invalid email or password"

    conn
    |> put_flash(:error, message)
    |> put_flash((login_as == "username" && :username) || :email, String.slice(value, 0, 160))
    |> redirect(to: ~p"/users/log_in")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
