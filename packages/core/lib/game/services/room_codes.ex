defmodule Game.Services.RoomCodes do
  @moduledoc """
  Service that allows to find roomId by room.code
  """
  use GenServer

  # Server
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    :ets.new(__MODULE__, [:set, :public, :named_table])

    {:ok, nil}
  end

  @spec insert(binary(), binary()) :: boolean()
  @spec delete(binary()) :: boolean()
  @spec get_room_id_by_code(binary()) :: binary() | nil

  # Client
  def insert(code, roomId) do
    :ets.insert(__MODULE__, {code, roomId})
  end

  def delete(code) do
    :ets.delete(__MODULE__, code)
  end

  def get_room_id_by_code(code) do
    case :ets.lookup(__MODULE__, code) do
      [{^code, room_id}] -> room_id
      [] -> nil
    end
  end
end
