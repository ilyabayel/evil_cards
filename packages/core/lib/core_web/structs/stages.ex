defmodule CoreWeb.Stages do
  def wait, do: "wait"
  def prepare, do: "prepare"
  def play, do: "play"
  def vote, do: "vote"
  def result, do: "result"

  def get_next_stage("wait"), do: "prepare"
  def get_next_stage("prepare"), do: "play"
  def get_next_stage("play"), do: "vote"
  def get_next_stage("vote"), do: "result"
  def get_next_stage("result"), do: "wait"
end
