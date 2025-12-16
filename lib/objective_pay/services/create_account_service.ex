defmodule ObjectivePay.Services.CreateAccountService do
  @moduledoc """
  Business logic to create a new account, checking for existence before insertion.
  """
  alias ObjectivePay.Commands.CreateAccountCommand
  alias ObjectivePay.Schemas.Account


  @spec execute(CreateAccountCommand.t()) ::
          {:ok, Account.t()} | {:error, :account_exists} | {:error, {:invalid_data, Ecto.Changeset.t()}}
  def execute(%CreateAccountCommand{} = command) do

    case Account.Repository.get_account_by_number(command.numero_conta) do
      {:ok, _account} ->
        {:error, :account_exists}

      {:error, :not_found} ->
        create_account_record(command)
    end
  end


  defp create_account_record(%CreateAccountCommand{} = command) do
    params = Map.from_struct(command)

    case Account.Repository.insert_account(params) do
      {:ok, account} ->
        {:ok, account}
    end
  end
end
