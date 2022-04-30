defmodule Game.SessionSupervisor do
  @moduledoc """
  This supervisor is responsible for Game Sessions.
  """
  use DynamicSupervisor
  alias Game.Services.Session

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_child(room) do
    child_specification = {Session, room}

    DynamicSupervisor.start_child(__MODULE__, child_specification)
  end

  @impl DynamicSupervisor
  def init(_arg) do
    # :one_for_one strategy: if a child process crashes, only that process is restarted.
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
