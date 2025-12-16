defmodule ObjectivePay.Services.GetAccountServiceTest do
  use ObjectivePay.DataCase, async: true

  import ObjectivePay.Factory

  alias ObjectivePay.Services.GetAccountService
  alias ObjectivePay.Commands.GetAccountCommand

  describe "get_account/1" do

    test "returns {:ok, account} for an existing account number" do
      existing_account = insert(:account, saldo: Decimal.new("1200.50"))

      params = %{numero_conta: existing_account.numero_conta}
      {:ok, command} = GetAccountCommand.build(params)

      result = GetAccountService.execute(command)

      assert {:ok, fetched_account} = result
      assert fetched_account.numero_conta == existing_account.numero_conta
      assert fetched_account.saldo == Decimal.new("1200.50")
    end

    test "returns {:error, :not_found} for a non-existent account number" do
      non_existent_number = 999999

      params = %{numero_conta: non_existent_number}
      {:ok, command} = GetAccountCommand.build(params)

      result = GetAccountService.execute(command)

      assert {:error, :not_found} = result
    end
  end
end
