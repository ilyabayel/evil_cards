defmodule CoreWeb.Stages do
  defstruct wait: "wait",
            prepare: "prepare",
            play: "play",
            winner_determination: "winner_determination",
            result: "result"
end
