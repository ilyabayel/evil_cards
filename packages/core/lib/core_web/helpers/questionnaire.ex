defmodule CoreWeb.QuestionnaireHelper do
  @doc """
    Generate list of options

    ## Examples

      iex> players = [
      ...>    %CoreWeb.User{name: "test1", id: "test1"},
      ...>    %CoreWeb.User{name: "test2", id: "test2"},
      ...>    %CoreWeb.User{name: "test3", id: "test3"},
      ...>  ]
      ...>  rounds_per_player = 3
      iex> CoreWeb.Room.get_options_map([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18], players, rounds_per_player)
      %{"test1" => [1,2,3,4,5,6], "test2" => [7,8,9,10,11,12], "test3" => [13,14,15,16,17,18]}
  """
  def get_options_map(options, players, rounds_per_player) do
    options_length = length(options)
    required = (length(players) + 3) * rounds_per_player

    options = expand_options(options, options_length, required)

    {map, _} =
      Enum.reduce(
        players,
        {%{}, options},
        &{
          Map.put(elem(&2, 0), &1.id, Enum.take(elem(&2, 1), rounds_per_player + 3)),
          Enum.drop(elem(&2, 1), rounds_per_player + 3)
        }
      )

    map
  end

  defp expand_options(opts, len, required) when len < required do
    expand_options(opts ++ opts, len * 2, required)
  end

  defp expand_options(opts, _, required) do
    Enum.take(opts, required)
  end
end
