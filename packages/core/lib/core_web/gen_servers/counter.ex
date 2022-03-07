defmodule CoreWeb.Counter do
  use GenServer

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  # Server
  @impl true
  def init(_state) do
    {:ok, 1000}
  end

  @impl true
  def handle_call(:get, _from, counter) do
    case counter do
      9999 -> {:reply, 9999, 1000}
      c -> {:reply, c, c + 1}
    end
  end
end
