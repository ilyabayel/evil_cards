let join = roomId => {
    Phoenix.Channel.make(SocketApi.instance, `room:${roomId}`, ())
    ->Phoenix.Channel.join(~timeout=1000, ())
}
