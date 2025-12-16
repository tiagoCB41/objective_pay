defmodule ObjectivePayWeb.AccountController.Fallback do
  @moduledoc false

  use ObjectivePayWeb, :controller

  @type error_reasons :: Ecto.Changeset.t() | :account_exists | {:invalid_data, Ecto.Changeset.t()}

  # 1. NOVO: CLÁUSULA PARA ERROS DIRETOS DO COMMAND/DTO BUILDER
  # CASOS: Quando a validação do DTO falha (ex: campo 'saldo' obrigatório não enviado, como no seu log).
  # Formato: {:error, %Ecto.Changeset{...}}
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: ObjectivePayWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, {:invalid_data, %Ecto.Changeset{} = changeset}}) do
   conn
    |> put_status(:bad_request)
    |> put_view(json: ObjectivePayWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :account_exists}) do
    send_resp(conn, 404, "")
  end

end
