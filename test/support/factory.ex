defmodule ObjectivePay.Factory do
  use ExMachina.Ecto, repo: ObjectivePay.Repo

  alias ObjectivePay.Schemas.Account
  alias Decimal

  def account_factory do
    %Account{
      numero_conta: sequence(:numero_conta, fn n -> 100000 + n end),
      saldo: Decimal.new("1000.00")
    }
  end

  def account_params_factory do
    %{
      numero_conta: sequence(:numero_conta, fn n -> 100000 + n end),
      saldo: "500.00"
    }
  end
end
