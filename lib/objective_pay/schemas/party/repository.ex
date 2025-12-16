defmodule ObjectivePay.Schemas.Account.Repository do
  @moduledoc false

  import Ecto.Query

  alias ObjectivePay.Repo
  alias ObjectivePay.Schemas.Account

  @spec get_account_by_number(integer()) :: {:ok, Account.t()} | {:error, :not_found}
  def get_account_by_number(numero_conta) do
    case Repo.get_by(Account, numero_conta: numero_conta) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

   @spec insert_account(map()) ::
          {:ok, Account.t()} | {:error, {:invalid_data, Ecto.Changeset.t()}}
  def insert_account(params) do
    %Account{}
    |> Account.changeset(params)
    |> Repo.insert()

    |> case do
      {:ok, account} ->
        {:ok, account}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, {:invalid_data, changeset}}
    end
  end
end
