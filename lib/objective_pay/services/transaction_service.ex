defmodule ObjectivePay.Services.TransactionService do
  @moduledoc """
  Business logic to process financial transactions, calculating fees
  and ensuring the balance does not become negative (no overdraft allowed).
  """

  require Decimal

  alias ObjectivePay.Commands.TransactionCommand
  alias ObjectivePay.Schemas.Account

  @type error_reason :: :not_found | :insufficient_balance | :unsupported_payment_method

  @debit_rate Decimal.new("0.03")
  @credit_rate Decimal.new("0.05")
  @pix_rate Decimal.new(0)

  @spec execute(TransactionCommand.t()) :: {:ok, Account.t()} | {:error, error_reason()}
  def execute(%TransactionCommand{numero_conta: num_conta, forma_pagamento: method, valor: valor}) do
    case Account.Repository.get_account_by_number(num_conta) do
      {:ok, account} ->
        case get_fee_rate(method) do
          {:ok, rate} ->
            total_cost = calculate_total_cost(valor, rate)
            process_debit(account, total_cost)

          {:error, reason} ->
            {:error, reason}
        end

      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  defp get_fee_rate(:debit_card), do: {:ok, @debit_rate}
  defp get_fee_rate(:credit_card), do: {:ok, @credit_rate}
  defp get_fee_rate(:pix), do: {:ok, @pix_rate}
  defp get_fee_rate(_), do: {:error, :unsupported_payment_method}

  defp calculate_total_cost(valor, rate) do
    multiplier = Decimal.add(Decimal.new(1), rate)
    Decimal.mult(valor, multiplier)
  end

  defp process_debit(%Account{} = account, total_cost) do
    current_saldo = account.saldo

    new_saldo = Decimal.sub(current_saldo, total_cost)

    if Decimal.compare(new_saldo, Decimal.new(0)) == :lt do
      {:error, :insufficient_balance}
    else
      # 3. Prepara as mudanças e persiste no Repositório
      changeset = Account.changeset(account, %{saldo: new_saldo})

      case Account.Repository.update_saldo(changeset) do
        {:ok, updated_account} ->
          {:ok, updated_account}

        {:error, changeset} ->
          {:error, :database_write_failure}
      end
    end
  end
end
