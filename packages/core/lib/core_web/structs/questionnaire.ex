defmodule CoreWeb.Questionnaire do
  @derive Jason.Encoder
  defstruct id: "",
            name: "",
            author: %CoreWeb.User{},
            questions: [],
            options: []
end
