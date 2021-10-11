defmodule CoreWeb.Questionnaires do
  use GenServer

  # Client

  def start_server() do
    GenServer.start_link(CoreWeb.RoomsState, %{}, name: {:global, :Questionnaires})
  end

  def read_from_file(path_to_questionnaire) do
    GenServer.call({:global, :Questionnaires}, :add_questionnaire)
  end

  def get_questions(questionnaire_id, number_of_questions) do
    GenServer.call({:global, :Questionnaires}, {:get, questionnaire_id})
  end

  @spec get_options(any, any) :: nil
  def get_options(questionnaire_id, number_of_options) do

  end

  # Server

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:get, questionnaire_id, }, _from, state) do
    {:reply, state[questionnaire_id], state}
  end

  @impl true
  def handle_cast({:put, %CoreWeb.Questionnaire{} = questionnaire}, state) do
    {:noreply, Map.put(state, String.to_atom(questionnaire.id), questionnaire)}
  end
end
