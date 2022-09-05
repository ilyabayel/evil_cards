defmodule CoreWeb.QuestionnaireHelper do
  @doc """
    Generate list of options

    ## Examples

      iex> players = [
      ...>    %Game.User{name: "test1", id: "test1"},
      ...>    %Game.User{name: "test2", id: "test2"},
      ...>    %Game.User{name: "test3", id: "test3"},
      ...>  ]
      iex>
      iex> rounds_per_player = 3
      iex>
      iex> options =
      ...>   Enum.to_list(1..18)
      ...>   |> Enum.map(&(%Game.Option{id: Integer.to_string(&1), text: Integer.to_string(&1)}))
      iex>
      iex> Game.Room.get_options_map(options, players, rounds_per_player)
      %{"test1" => Enum.slice(options, 0, 6), "test2" => Enum.slice(options, 6, 6), "test3" => Enum.slice(options, 12, 6)}
  """
  @spec get_options_map([Game.Option.t()], [Game.User.t()], integer()) :: map()
  def get_options_map(options, players, rounds_per_player) do
    options_length = length(options)
    start_cards = 6
    cards_to_be_used_by_player = (length(players) - 1) * rounds_per_player
    required_cards_per_player = start_cards + cards_to_be_used_by_player
    required_cards = length(players) * required_cards_per_player

    options = expand_options(options, options_length, required_cards)

    {map, _} =
      Enum.reduce(
        players,
        {%{}, options},
        &{
          Map.put(elem(&2, 0), &1.id, Enum.take(elem(&2, 1), required_cards_per_player)),
          Enum.drop(elem(&2, 1), required_cards_per_player)
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
