defmodule CoreWeb.Questionnaires do
  use GenServer

  @spec start_server :: :ignore | {:error, any} | {:ok, pid}
  @spec put(CoreWeb.Questionnaire.t()) :: :ok
  @spec generate_game_set(CoreWeb.Room.t()) :: any

  # Client

  def start_server() do
    GenServer.start_link(CoreWeb.RoomsState, %{}, name: {:global, :Questionnaires})
  end

  def put(%CoreWeb.Questionnaire{} = questionnaire) do
    GenServer.cast({:global, :Questionnaires}, {:put, questionnaire})
  end

  def generate_game_set(%CoreWeb.Room{} = room) do
    GenServer.call({:global, :Questionnaires}, {:generate_game_set, room})
  end

  # Server

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:generate_game_set, room}, _from, state) do
    # TODO: Create Game Set
    # Return Set of Questions for game
    # Return Set of Options for every single player
    {:reply, Map.get(state, room.questionnaire_id), state}
  end

  @impl true
  def handle_cast({:put, %CoreWeb.Questionnaire{} = questionnaire}, state) do
    {:noreply, Map.put(state, String.to_atom(questionnaire.id), questionnaire)}
  end
end
