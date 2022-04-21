defmodule Core.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      CoreWeb.Telemetry,
      {Phoenix.PubSub, name: Core.PubSub},
      {Task.Supervisor, name: Core.TaskSupervisor},
      CoreWeb.Endpoint,
      Game.Services.RoomCodes,
      Game.SessionRegistry,
      Game.Services.Questionnaires,
      Game.RoomSupervisor,
      Game.Services.Counter,
    ]


    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
