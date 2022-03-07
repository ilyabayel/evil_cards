defmodule CoreWeb.Counter do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> 1000 end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def increment do
    Agent.update(
      __MODULE__,
      &case &1 do
        9999 -> 1000
        value -> value + 1
      end
    )
  end
end
