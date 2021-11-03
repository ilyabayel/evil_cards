defmodule CoreWeb.LobbyChannelTest do
  use CoreWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      CoreWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(CoreWeb.LobbyChannel, "lobby:main")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    host = %{"id" => "1234", "name" =>  "test"}
    ref = push(socket, "create_room", %{"host" => host})
    assert_reply(ref, :ok, "" <> _message)
  end
end
