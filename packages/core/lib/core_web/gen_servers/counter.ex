defmodule CoreWeb.Counter do
  use GenServer

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  @spec get :: integer()

  # Client
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: {:global, :Counter})
  end

  def get() do
    GenServer.call({:global, :Counter}, :get)
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
