defmodule ObjectivePay.Commands.CreateAccountCommand do
  use ObjectivePay.EmbeddedSchema

  @type t :: %__MODULE__{
           numero_conta: integer(),
           saldo: float()
         }

  @required [:numero_conta, :saldo]
  @optional []

  embedded_schema do
    field(:numero_conta, :integer)
    field(:saldo, :float)
  end

@spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
