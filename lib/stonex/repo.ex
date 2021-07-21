defmodule Stonex.Repo do
  use Ecto.Repo,
    otp_app: :stonex,
    adapter: Ecto.Adapters.Postgres
end
