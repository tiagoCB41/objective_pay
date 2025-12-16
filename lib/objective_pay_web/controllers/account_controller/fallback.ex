defmodule ObjectivePayWeb.AccountController.Fallback do
  @moduledoc false

  use ObjectivePayWeb, :controller

  @type error_reasons :: Ecto.Changeset.t()

def call(conn, {:error, {:invalid_data, %Ecto.Changeset{} = changeset}}) do
    conn
    |> put_status(400)
    |> put_view(json: ObjectivePayWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :account_exists}) do
    conn
    |> put_status(404)
    |> json(%{
      error: "account_exists",
      message:
        "Account creation failed: An account with the provided details already exists."
    })
  end
end
