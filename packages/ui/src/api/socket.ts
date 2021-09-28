import { Socket, Channel } from "phoenix"
import type { I_Option, I_Question, I_RoomInfo, I_User } from "src/models/room"

const socket = new Socket("ws://localhost:4000/socket", { params: { userName: "Ilya", userId: "ilya1234" } })
socket.connect()

export const LobbyApi = (() => {
  const _lobby = socket.channel("lobby:main")
  _lobby.join()

  return {
    createRoom(host: I_User): Promise<string> {
      return new Promise((res, rej) => {
        _lobby.push("create_room", { host })
          .receive("ok", (reply) => res(reply))
          .receive("error", (reply) => rej(reply))
          .receive("timeout", (reply) => rej(reply))
      })
    },
    getRoomIdByCode(code: number): Promise<string> {
      return new Promise((res, rej) => {
        _lobby.push("get_room_by_code", { code })
          .receive("ok", (reply) => res(reply))
          .receive("error", (reply) => rej(reply))
          .receive("timeout", (reply) => rej(reply))
      })
    }
  }
})()


export class RoomApi {
  private _room: Channel

  constructor(roomId: string) {
    this._room = socket.channel(`room:${roomId}`)
  }

  public onRoomUpdate(callback): RoomApi {
    this._room.on("room_update", callback)
    return this
  }

  public answer(option: I_Option): Promise<void> {
    return new Promise((res, rej) => {
      this._room.push("answer", option)
        .receive("ok", () => res())
        .receive("error", (reply) => rej(reply))
        .receive("timeout", (reply) => rej(reply))
    })
  }

  public chooseWinner(player: I_User): Promise<void> {
    return new Promise((res, rej) => {
      this._room.push("choose_winner", { player })
        .receive("ok", () => res())
        .receive("error", (reply) => rej(reply))
        .receive("timeout", (reply) => rej(reply))
    })
  }

  public finishRound(): Promise<void> {
    return new Promise((res, rej) => {
      this._room.push("finish_round", {})
        .receive("ok", () => res())
        .receive("error", (reply) => rej(reply))
        .receive("timeout", (reply) => rej(reply))
    })
  }

  public join(): Promise<I_RoomInfo> {
    return new Promise((res, rej) => {
      this._room.join()
        .receive("ok", (reply) => res(reply))
        .receive("error", (reply) => rej(reply))
        .receive("timeout", (reply) => rej(reply))
    })
  }

  public leave(): Promise<void> {
    return new Promise((res, rej) => {
      this._room.push("leave", {})
        .receive("ok", () => {
          this._room.leave()
          res()
        })
        .receive("error", (res) => rej(res))
        .receive("timeout", (res) => rej(res))
    })
  }
}