import App from './app.svelte'
import { Socket } from "phoenix"

const socket = new Socket("ws://localhost:4000/socket")

socket.connect()

const lobby = socket.channel("room:lobby")

lobby.join()
  .receive("ok", (res) => console.log(res))

function createRoom() {
  lobby.push("create", {host: {name: "Ilya", id: "1"}}).receive("ok", (reply) => {
    reply.id && joinRoom(reply.id)
  })
}

function joinRoom(id: string) {
  const room = socket.channel(`room:${id}`, {player: {name: "Ilya", id: "ilya1"}})

  room.join()
    .receive("ok", (reply) => {
      console.log("Joined room", reply)
    })
    .receive("error", ({reason}) => {
      console.log("Cannot join.", reason)
      room.leave()
    })
    .receive("timeout", () => console.log("Networking issue. Still waiting..."))

  lobby.push("get_rooms", {}).receive("ok", (rooms) => console.log(rooms))
}

createRoom()



const app = new App({
  target: document.getElementById('app')
})

export default app
