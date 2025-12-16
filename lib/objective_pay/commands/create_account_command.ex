defmodule ObjectivePay.Commands.CreateAccountCommand do
  @moduledoc """
  DTO to validate and structure to the create_account.
  """

  use ObjectivePay.EmbeddedSchema
  alias Decimal

  @type t :: %__MODULE__{
           numero_conta: integer(),
           saldo: Decimal.t()
         }

  @required [:numero_conta, :saldo]
  @optional []

  embedded_schema do
    field(:numero_conta, :integer)
    field(:saldo, :decimal)
  end

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @required)
    |> Ecto.Changeset.validate_required(@required)
    |> Ecto.Changeset.validate_number(:numero_conta, greater_than: 0)
    |> Ecto.Changeset.validate_number(:saldo, greater_than_or_equal_to: 0)
  end
end
