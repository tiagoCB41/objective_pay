defmodule ObjectivePay.Services.TransactionServiceTest do
  use ObjectivePay.DataCase, async: true

  import ObjectivePay.Factory

  alias ObjectivePay.Services.TransactionService
  alias ObjectivePay.Commands.TransactionCommand
  alias ObjectivePay.Schemas.Account

  require Decimal
  @debit_rate Decimal.new("0.03")
  @credit_rate Decimal.new("0.05")

  describe "execute/1" do

    setup do
      account = insert(:account, saldo: Decimal.new("1000.00"))
      {:ok, %{account: account}}
    end

    test "returns {:ok, account} and debits with PIX (0% fee)", %{account: account} do
      valor = "100.00"
      valor_decimal = Decimal.new(valor)

      params = %{
        numero_conta: account.numero_conta,
        forma_pagamento: "P",
        valor: valor
      }
      {:ok, command} = TransactionCommand.build(params)

      result = TransactionService.execute(command)

      expected_saldo = Decimal.sub(Decimal.new("1000.00"), valor_decimal)

      assert {:ok, updated_account} = result
      assert updated_account.saldo == expected_saldo
      assert Account.Repository.get_account_by_number(account.numero_conta) |> elem(1) |> Map.get(:saldo) == expected_saldo
    end

    test "returns {:ok, account} and debits with Debit Card (3% fee)", %{account: account} do
      valor = "100.00"
      valor_decimal = Decimal.new(valor)
      total_cost = Decimal.mult(valor_decimal, Decimal.add(Decimal.new(1), @debit_rate))

      params = %{
        numero_conta: account.numero_conta,
        forma_pagamento: "D",
        valor: valor
      }
      {:ok, command} = TransactionCommand.build(params)

      result = TransactionService.execute(command)

      expected_saldo = Decimal.sub(Decimal.new("1000.00"), total_cost)

      assert {:ok, updated_account} = result
      assert updated_account.saldo == expected_saldo
    end

    test "returns {:ok, account} and debits with Credit Card (5% fee)", %{account: account} do
      valor = "100.00"
      decimal_valor = Decimal.new(valor)
      total_cost = Decimal.mult(decimal_valor, Decimal.add(Decimal.new(1), @credit_rate))

      params = %{
        numero_conta: account.numero_conta,
        forma_pagamento: "C",
        valor: valor
      }
      {:ok, command} = TransactionCommand.build(params)

      result = TransactionService.execute(command)

      expected_saldo = Decimal.sub(Decimal.new("1000.00"), total_cost)

      assert {:ok, updated_account} = result
      assert updated_account.saldo == expected_saldo
    end

    test "returns {:error, :insufficient_balance} if total cost exceeds balance", %{account: account} do
      valor = "952.40"

      params = %{
        numero_conta: account.numero_conta,
        forma_pagamento: "C",
        valor: valor
      }
      {:ok, command} = TransactionCommand.build(params)

      result = TransactionService.execute(command)

      assert {:error, :insufficient_balance} = result

      assert Account.Repository.get_account_by_number(account.numero_conta) |> elem(1) |> Map.get(:saldo) == Decimal.new("1000.00")
    end

    test "returns error if command build fails due to invalid payment method format" do
      params = %{
        numero_conta: 12345,
        forma_pagamento: "B",
        valor: "10.00"
      }

      assert {:error, changeset} = TransactionCommand.build(params)

      assert errors_on(changeset).forma_pagamento != nil
    end

    test "returns {:error, :not_found} for a non-existent account number" do
      non_existent_number = 999999

      params = %{
        numero_conta: non_existent_number,
        forma_pagamento: "P",
        valor: "10.00"
      }
      {:ok, command} = TransactionCommand.build(params)

      result = TransactionService.execute(command)

      assert {:error, :not_found} = result
    end

  end
end
