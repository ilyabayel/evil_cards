import App from './app.svelte'
import { LobbyApi, RoomApi } from './api/socket'

// LobbyApi.createRoom({ id: "user_id", name: "user_name" })
//   .then(async (res) => {
//     const room = new RoomApi(res).onRoomUpdate(console.log)

//     await room.join()

//     room.answer({ id: "q1", text: "qtext" }, { id: "o1", text: "otext" })
//   })
//   .catch(err => console.log("error creating room", err))


const room = new RoomApi("956e064c-cf0c-4006-a36c-6e5946b48d34").onRoomUpdate(console.log)

await room.join()

room.answer({ id: "o1", text: "otext" })

const app = new App({
  target: document.getElementById('app')
})

export default app
