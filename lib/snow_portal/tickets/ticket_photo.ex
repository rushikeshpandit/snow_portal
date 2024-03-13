defmodule SnowPortal.TicketPhoto do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .png .svg .doc .docx .txt .rar .zip .pdf)

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(@extension_whitelist, file_extension) do
      true -> :ok
      false -> {:error, "file type is invalid"}
    end
  end

  def storage_dir(_, {_file, ticket_images}) do
    "uploads/ticket_image/#{ticket_images.ticket_id}"
  end
end
