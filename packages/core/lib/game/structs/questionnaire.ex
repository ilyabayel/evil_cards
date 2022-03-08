defmodule Game.Questionnaire do
  @derive Jason.Encoder
  defstruct id: "",
            name: "",
            author: %Game.User{},
            questions: [],
            options: []

  @typedoc """
  A room where all actions are stored
  """
  @type t :: %__MODULE__{
    id: String.t(),
    name: String.t(),
    author: Game.User.t(),
    questions: [Game.Question.t()],
    options: [Game.Option.t()],
  }

  @spec create_from_file(String.t()) :: {:error, atom | Jason.DecodeError.t()} | {:ok, Game.Questionnaire.t()}
  @spec create_from_hashmap(map) :: Game.Questionnaire.t()


  def create_from_file(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body)
    do
      {:ok, create_from_hashmap(json)}
    else
      err -> err
    end
  end


  def create_from_hashmap(%{"questions" => questions, "options" => options, "name" => name}) do
    questions =
      Enum.map(
        questions,
        fn q ->
          %Game.Question{
            id: UUID.uuid4(),
            text: q
          }
        end
      )

    options =
      Enum.map(
        options,
        fn o ->
          %Game.Option{
            id: UUID.uuid4(),
            text: o
          }
        end
      )

    %Game.Questionnaire{
      id: UUID.uuid4(),
      name: name,
      author: %Game.User{},
      questions: questions,
      options: options
    }
  end
end
