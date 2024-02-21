defmodule SnowPortalWeb.UserSessionControllerTest do
  use SnowPortalWeb.ConnCase, async: true

  import SnowPortal.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "POST /users/log_in" do
    test "logs the user in", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/log_in", %{
          "user" => %{
            "user_name" => user.user_name,
            "password" => valid_user_password(),
            "login_as" => "username"
          }
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/customer/dashboard"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ ~p"/users/settings"
      assert response =~ ~p"/users/log_out"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/log_in", %{
          "user" => %{
            "user_name" => user.user_name,
            "password" => valid_user_password(),
            "remember_me" => "true",
            "login_as" => "username"
          }
        })

      assert conn.resp_cookies["_snow_portal_web_user_remember_me"]
      assert redirected_to(conn) == ~p"/customer/dashboard"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session(user_return_to: "/foo/bar")
        |> post(~p"/users/log_in", %{
          "user" => %{
            "user_name" => user.user_name,
            "password" => valid_user_password(),
            "login_as" => "username"
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "login following registration", %{conn: conn, user: user} do
      conn =
        conn
        |> post(~p"/users/log_in", %{
          "_action" => "registered",
          "user" => %{
            "user_name" => user.user_name,
            "password" => valid_user_password(),
            "login_as" => "username"
          }
        })

      assert redirected_to(conn) == ~p"/customer/dashboard"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Account created successfully"
    end

    test "login following password update", %{conn: conn, user: user} do
      conn =
        conn
        |> post(~p"/users/log_in", %{
          "_action" => "password_updated",
          "user" => %{
            "user_name" => user.user_name,
            "password" => valid_user_password(),
            "login_as" => "username"
          }
        })

      assert redirected_to(conn) == ~p"/users/settings"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Password updated successfully"
    end

    test "redirects to login page with invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/users/log_in", %{
          "user" => %{
            "user_name" => "invalid@email.com",
            "password" => "invalid_Password!1",
            "login_as" => "username"
          }
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid username or password"
      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end

  describe "DELETE /users/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(~p"/users/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/users/log_out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
