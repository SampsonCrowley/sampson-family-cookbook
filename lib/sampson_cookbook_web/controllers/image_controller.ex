defmodule SampsonCookbookWeb.ImageController do
  use SampsonCookbookWeb, :controller

  alias SampsonCookbook.Repo
  alias SampsonCookbook.Image

  def show(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)
    conn
    |> encode_image(image)
  end

  def preview(conn, %{"id" => id}) do
    preview = Image.get_preview!(id)
    conn
    |> encode_image(preview, true)
  end

  defp encode_image(conn, image, preview \\ false)
  defp encode_image(conn, image, preview) do
    conn
    |> put_layout(:none)
    |> put_resp_content_type(image.image_type)
    |> resp(200, :base64.decode(if preview, do: image.preview.data, else: image.image_data))
    |> send_resp()
    |> halt()
  end
end
