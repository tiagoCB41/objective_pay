defmodule ObjectivePay.Release do
  @moduledoc false
  @app :objective_pay

  @spec migrate() :: :ok
  def migrate do
    load_app()

    for repo <- repos() do
      IO.puts("Running migrations for repo #{inspect(repo)}...")

      {:ok, _fn_return, _apps} =
        Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end

    :ok
  end

  @spec rollback(repo :: module(), version :: integer()) :: :ok
  def rollback(repo, version) do
    load_app()

    {:ok, _fn_return, _apps} =
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))

    :ok
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
