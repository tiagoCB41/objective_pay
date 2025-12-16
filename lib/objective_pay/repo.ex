defmodule ObjectivePay.Repo do
  use Ecto.Repo,
    otp_app: :objective_pay,
    adapter: Ecto.Adapters.Postgres
end
