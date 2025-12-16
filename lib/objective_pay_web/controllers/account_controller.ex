defmodule ObjectivePayWeb.AccountController do
  @moduledoc false

  use ObjectivePayWeb, :controller

  action_fallback ObjectivePayWeb.AccountController.Fallback

  alias ObjectivePay.Commands.CreateAccountCommand
  alias ObjectivePay.Services.CreateAccountService

  def create_account(conn, params) do
    with {:ok, %CreateAccountCommand{} = command} <-
           CreateAccountCommand.build(params),
         {:ok, account} <- CreateAccountService.execute(command) do
      render(conn, :create_account , account: account)
    end
  end
end
