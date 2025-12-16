defmodule ObjectivePay.Schema do
  @moduledoc """
  Defines commom module attributes for Core application Ecto schemas.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key {:id, :binary_id, autogenerate: true}
      @timestamps_opts [type: :utc_datetime_usec]
      @foreign_key_type :binary_id
    end
  end
end
