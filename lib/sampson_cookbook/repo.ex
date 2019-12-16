defmodule SampsonCookbook.Repo do
  use Ecto.Repo,
    otp_app: :sampson_cookbook,
    adapter: Ecto.Adapters.Postgres
end
