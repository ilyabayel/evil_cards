defmodule CoreWeb.RoomChannelTest do
  use CoreWeb.ChannelCase

  # setup do
  #   {:ok, _, socket} =
  #     CoreWeb.UserSocket
  #     |> socket("user_id", %{some: :assign})
  #     |> subscribe_and_join(CoreWeb.RoomChannel, "room:1234")

  #     IO.inspect(socket)

  #   %{socket: socket}
  # end

  # test "ping replies with status ok", %{socket: socket} do
  #   ref = push(socket, "create_room", %{"host" => })
  #   assert_reply ref, :ok, %{"hello" => "there"}
  # end

  # test "shout broadcasts to room:lobby", %{socket: socket} do
  #   push socket, "shout", %{"hello" => "all"}
  #   assert_broadcast "shout", %{"hello" => "all"}
  # end

  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
