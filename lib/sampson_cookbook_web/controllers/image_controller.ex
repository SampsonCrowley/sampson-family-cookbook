defmodule SampsonCookbookWeb.ImageController do
  use SampsonCookbookWeb, :controller

  alias SampsonCookbook.Repo
  alias SampsonCookbook.Image

  def index(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)
    conn
    |> encode_image(image)
  end

  defp encode_image(conn, image) do
    conn
    |> put_layout(:none)
    |> put_resp_content_type(image.image_type)
    |> resp(200, :base64.decode(image.image_data))
    |> send_resp()
    |> halt()
  end
end
