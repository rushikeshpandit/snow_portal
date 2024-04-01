defmodule SnowPortal.TicketPhoto do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .png .svg .doc .docx .txt .rar .zip .pdf)

  def filename(version, {file, post}) do
    # It is desirable for this name to be unique
    "#{file.file_name}_#{post.ticket_id}_#{version}"
  end

  def validate(_version, {file, _scope}) do
    file_extension =
      file.file_name
      |> Path.extname()
      |> String.downcase()

    Enum.member?(@extension_whitelist, file_extension)
  end
end
