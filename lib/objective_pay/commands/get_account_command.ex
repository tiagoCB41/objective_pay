defmodule ObjectivePay.Commands.GetAccountCommand do
  @moduledoc """
  DTO to validate and structure the 'numero_conta' query parameter.
  """
  use ObjectivePay.EmbeddedSchema

  import Ecto.Changeset

  @type t() :: %__MODULE__{
    numero_conta: integer()
  }

  @primary_key false
  embedded_schema do
    field :numero_conta, :integer
  end

  @required [:numero_conta]

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:numero_conta, greater_than: 0)
  end

  @spec build(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def build(params) do
    changeset = changeset(params)

    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end
end
