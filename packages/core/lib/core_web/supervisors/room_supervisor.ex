defmodule CoreWeb.RoomSupervisor do
  @moduledoc """
  This supervisor is responsible game child processes.
  """
  use DynamicSupervisor
  alias CoreWeb.GenServers.Room

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(room_id) do
    child_specification = {Room, room_id}

    DynamicSupervisor.start_child(__MODULE__, child_specification)
  end

  @impl DynamicSupervisor
  def init(_arg) do
    # :one_for_one strategy: if a child process crashes, only that process is restarted.
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
