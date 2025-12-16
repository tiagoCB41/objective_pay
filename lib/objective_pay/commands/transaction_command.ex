defmodule ObjectivePay.Commands.TransactionCommand do
  @moduledoc """
  DTO for transaction validation, overriding 'build/1' to handle Changeset validation
  and converting payment form string to atom.
  """
  use Ecto.Schema
  import Ecto.Changeset
  require Decimal

  @primary_key false
  embedded_schema do
    field :forma_pagamento, :string
    field :numero_conta, :integer
    field :valor, :decimal
  end

  @required [:forma_pagamento, :numero_conta, :valor]

  @type payment_method :: :pix | :credit_card | :debit_card
  @type t() :: %__MODULE__{
    forma_pagamento: payment_method(),
    numero_conta: integer(),
    valor: Decimal.t()
  }

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:numero_conta, greater_than: 0)
    |> validate_number(:valor, greater_than: Decimal.new(0))
    |> cast_payment_method()
  end

  defp cast_payment_method(changeset) do
    case fetch_change(changeset, :forma_pagamento) do
      {:ok, "P"} -> put_change(changeset, :forma_pagamento, :pix)
      {:ok, "C"} -> put_change(changeset, :forma_pagamento, :credit_card)
      {:ok, "D"} -> put_change(changeset, :forma_pagamento, :debit_card)
      {:ok, _} ->
        add_error(changeset, :forma_pagamento, "forma de pagamento inválida. Use P, C ou D.")
      :error ->
        changeset
    end
  end

  @spec build(map()) :: {:ok, __MODULE__.t()} | {:error, Ecto.Changeset.t()}
  def build(params) do
    changeset = changeset(params)

    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end
end
