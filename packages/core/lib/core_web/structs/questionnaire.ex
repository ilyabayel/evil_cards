defmodule CoreWeb.Questionnaire do
  @derive Jason.Encoder
  defstruct id: "",
            name: "",
            author: %CoreWeb.User{},
            questions: [],
            options: []

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
          %CoreWeb.Question{
            id: UUID.uuid4(),
            text: q
          }
        end
      )

    options =
      Enum.map(
        options,
        fn o ->
          %CoreWeb.Option{
            id: UUID.uuid4(),
            text: o
          }
        end
      )

    %CoreWeb.Questionnaire{
      id: UUID.uuid4(),
      name: name,
      author: %CoreWeb.User{},
      questions: questions,
      options: options
    }
  end
end
