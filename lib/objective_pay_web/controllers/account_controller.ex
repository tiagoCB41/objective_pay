defmodule ObjectivePayWeb.AccountController do
  @moduledoc false

  use ObjectivePayWeb, :controller

  action_fallback ObjectivePayWeb.AccountController.Fallback

  alias ObjectivePay.Commands.CreateAccountCommand
  alias ObjectivePay.Commands.GetAccountCommand
  alias ObjectivePay.Commands.TransactionCommand
  alias ObjectivePay.Services.CreateAccountService
  alias ObjectivePay.Services.GetAccountService
  alias ObjectivePay.Services.TransactionService

  def create_account(conn, params) do
    with {:ok, %CreateAccountCommand{} = command} <-
           CreateAccountCommand.build(params),
         {:ok, account} <- CreateAccountService.execute(command) do
      conn
      |> put_status(201)
      |> render(:show_account, account: account)
    end
  end

  def show_account(conn, params) do
    with {:ok, %GetAccountCommand{} = command} <- GetAccountCommand.build(params),
         {:ok, account} <- GetAccountService.execute(command) do
      conn
      |> put_status(:ok)
      |> render(:show_account, account: account)

      else
        _any_error ->
          send_resp(conn, 404, "")
    end
  end

  def create_transaction(conn, params) do
    with {:ok, %TransactionCommand{} = command} <- TransactionCommand.build(params),
         {:ok, updated_account} <- TransactionService.execute(command) do

      conn
      |> put_status(201)
      |> render(:show_account, account: updated_account)

    else
       _any_error ->
          send_resp(conn, 404, "")
    end
  end
end
