defmodule ObjectivePay.Schemas.Account do
  @moduledoc """
  Schema definition for account table.
  """

  use ObjectivePay.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          numero_conta: integer(),
          saldo: float(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @required [:numero_conta, :saldo]
  @optional []

  schema "account" do
    field :numero_conta, :integer
    field :saldo, :float, default: 0.0

    timestamps()
  end

  @spec changeset(%__MODULE__{} | t(), map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:numero_conta, greater_than: 0)
    |> validate_number(:saldo, greater_than_or_equal_to: 0)
    |> unique_constraint(:numero_conta)
  end
end
