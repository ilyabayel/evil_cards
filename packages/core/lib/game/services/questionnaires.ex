defmodule Game.Services.Questionnaires do
  use GenServer

  @spec put(Game.Questionnaire.t()) :: :ok
  @spec generate_game_set(Game.Room.t()) :: any

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def put(%Game.Questionnaire{} = questionnaire) do
    GenServer.cast(__MODULE__, {:put, questionnaire})
  end

  def generate_game_set(%Game.Room{} = room) do
    GenServer.call(__MODULE__, {:generate_game_set, room})
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
  def handle_cast({:put, %Game.Questionnaire{} = questionnaire}, state) do
    {:noreply, Map.put(state, String.to_atom(questionnaire.id), questionnaire)}
  end
end
