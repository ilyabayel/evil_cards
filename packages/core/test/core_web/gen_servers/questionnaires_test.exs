defmodule CoreWeb.QuestionairesTest do
  use ExUnit.Case, async: true

  test "creates from file" do
    result = Game.Questionnaire.create_from_file("test/test_questionaire.json")
    questionnaire = elem(result, 1)
    assert questionnaire.name == "test"
    assert Enum.at(questionnaire.questions, 0).text == "question"
    assert Enum.at(questionnaire.options, 0).text == "option"
  end

  test "returns error if file not exists" do
    result = Game.Questionnaire.create_from_file("test/non_existant_file.json")
    assert elem(result, 0) == :error
  end

  test "creates from hashmap" do
    map = %{"name" => "test", "questions" => ["question"], "options" => ["option"]}
    questionnaire = Game.Questionnaire.create_from_hashmap(map)
    assert questionnaire.name == "test"
    assert Enum.at(questionnaire.questions, 0).text == "question"
    assert Enum.at(questionnaire.options, 0).text == "option"
  end
end
