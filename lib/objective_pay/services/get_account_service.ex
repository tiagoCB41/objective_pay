defmodule ObjectivePay.Services.GetAccountService do
  @moduledoc """
  Business logic for retrieving an existing account.

  Delegates the lookup operation to the Account Repository.
  """
  alias ObjectivePay.Commands.GetAccountCommand
  alias ObjectivePay.Schemas.Account

  @spec execute(GetAccountCommand.t()) :: {:ok, Account.t()} | {:error, :not_found}
  def execute(%GetAccountCommand{numero_conta: numero_conta}) do
    Account.Repository.get_account_by_number(numero_conta)
  end
end
