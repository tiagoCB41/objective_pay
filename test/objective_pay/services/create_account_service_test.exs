defmodule ObjectivePay.Services.CreateAccountServiceTest do
  use ObjectivePay.DataCase, async: true

  import ObjectivePay.Factory

  alias ObjectivePay.Services.CreateAccountService
  alias ObjectivePay.Commands.CreateAccountCommand
  alias ObjectivePay.Schemas.Account

  describe "execute/1" do

    test "returns {:ok, account} and creates a new account with valid data" do
      params = %{
        numero_conta: 1000,
        saldo: 10
      }

      {:ok, command} = CreateAccountCommand.build(params)

      result = CreateAccountService.execute(command)

      assert {:ok, account} = result

      assert account.numero_conta == command.numero_conta

      assert {:ok, fetched_account} = Account.Repository.get_account_by_number(account.numero_conta)
      assert fetched_account.id == account.id
    end

    test "returns {:error, :account_exists} if the account number already exists" do
      existing_account = insert(:account)

      params = %{
        numero_conta: existing_account.numero_conta,
        saldo: Decimal.new("50.00")
      }

      {:ok, command} = CreateAccountCommand.build(params)

      result = CreateAccountService.execute(command)

      assert {:error, :account_exists} = result
    end

  end
end
