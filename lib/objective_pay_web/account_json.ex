defmodule ObjectivePayWeb.AccountJSON do
  @moduledoc """
  Renders the JSON responses for the AccountController, mapping Ecto structs
  into the final API structure.
  """
  alias ObjectivePay.Schemas.Account
  alias Decimal

  @type assigns :: %{
           :account => ObjectivePay.Schemas.Account.t(),
           optional(any()) => any()
         }

  @spec show_account(assigns()) :: %{String.t() => integer() | Decimal.t()}
  def show_account(assigns) do
    %{account: %Account{} = account} = assigns

    %{
      "numero_conta" => account.numero_conta,
      "saldo" => account.saldo
    }
  end
end
