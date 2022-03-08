defmodule CoreWeb.QuestionnaireHelper do
  @spec get_options_map([Game.Option.t()], [Game.User.t()], integer()) :: map

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
