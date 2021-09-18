package main

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"log"
	"net/http"
	"strings"

	// Import this library.
	"github.com/centrifugal/centrifuge"
	"github.com/google/uuid"
	"github.com/julienschmidt/httprouter"
)

func auth(h http.Handler) func(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	return func(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
		ctx := r.Context()
		cred := &centrifuge.Credentials{
			UserID: "",
		}
		newCtx := centrifuge.SetCredentials(ctx, cred)
		r = r.WithContext(newCtx)
		h.ServeHTTP(w, r)
	}
}

func (room *Room) AddPlayer(player *User) {
	room.Players = append(room.Players, player)
}

func (room *Room) RemovePlayer(playerId string) {
	for i := range room.Players {
		if room.Players[i].ID == playerId {
			room.Players = append(room.Players[:i+1], room.Players[i+2:]...)
		}
	}
}

func main() {
	router := httprouter.New()
	cfg := centrifuge.DefaultConfig

	rooms := map[string]*Room{}
	roomCounter := 0
	codes := map[string]string{}
	code := 1000

	node, err := centrifuge.New(cfg)
	if err != nil {
		log.Fatal(err)
	}

	node.OnConnect(func(client *centrifuge.Client) {
		transportName := client.Transport().Name()
		transportProto := client.Transport().Protocol()
		log.Printf("client connected via %s (%s)", transportName, transportProto)

		client.OnSubscribe(func(e centrifuge.SubscribeEvent, cb centrifuge.SubscribeCallback) {
			roomId := strings.ReplaceAll(e.Channel, "room:", "")

			if rooms[roomId].ID == "" {
				cb(centrifuge.SubscribeReply{}, errors.New("Room not exists"))
				return
			}

			log.Printf("client subscribes on channel %s", e.Channel)

			room := rooms[roomId]

			log.Println(room)

			room.AddPlayer()

			rooms[roomId] = room

			data, _ := json.Marshal(rooms[roomId])

			cb(centrifuge.SubscribeReply{
				Options: centrifuge.SubscribeOptions{
					Data: data,
				},
			}, nil)

			node.Publish(e.Channel, data)
		})

		client.OnPublish(func(e centrifuge.PublishEvent, cb centrifuge.PublishCallback) {
			log.Printf("client publishes into channel %s: %s", e.Channel, string(e.Data))
			cb(centrifuge.PublishReply{}, nil)
		})

		client.OnDisconnect(func(e centrifuge.DisconnectEvent) {
			log.Printf("client disconnected")
		})
	})

	if err := node.Run(); err != nil {
		log.Fatal(err)
	}

	wsHandler := centrifuge.NewWebsocketHandler(node, centrifuge.WebsocketConfig{})

	router.GET("/connection/websocket", auth(wsHandler))
	router.ServeFiles("/src/*filepath", http.Dir("./assets/"))
	router.POST("/rooms/create", func(w http.ResponseWriter, req *http.Request, _ httprouter.Params) {
		roomId := uuid.NewString()
		room := CreateRoom(&CreateRoomProps{Username: "", RoundsPerPlayer: 3, RoundDuration: 60, Code: ""})

		rooms[roomId] = room

		codes[room.Code] = roomId

		data, _ := json.Marshal(room)
		w.Write(data)
		roomCounter += 1
		code += 1
		if code >= 9999 {
			code = 1000
		}
	})
	router.GET("/rooms/getByCode/:code", func(w http.ResponseWriter, req *http.Request, params httprouter.Params) {
		log.Println("Params " + params.ByName("code"))
		code := params.ByName("code")

		if code == "" {
			w.WriteHeader(http.StatusBadRequest)
			w.Header().Set("Content-Type", "application/json")
			w.Write([]byte("Code is not correct"))
			return
		}

		roomId := codes[code]

		log.Println(codes)
		log.Println(roomId)

		if roomId == "" {
			log.Println("Code doesn't exist")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte("Code doesn't exist"))
			return
		}

		room := rooms[roomId]

		if room.Id == "" {
			log.Println("Room doesn't exist")
			w.WriteHeader(http.StatusNotFound)
			w.Header().Set("Content-Type", "application/json")
			w.Write([]byte("Room doesn't exist"))
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte(room.Id))
	})

	router.POST("/rooms/start", func(w http.ResponseWriter, req *http.Request, params httprouter.Params) {
		reqestBody, err := ioutil.ReadAll(req.Body)

		reqestBody = []byte(strings.ReplaceAll(string(reqestBody), "\n", ""))

		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte(err.Error()))
		}

		body := struct {
			HostId string `json:"hostId"`
			RoomId string `json:"roomId"`
		}{}

		err = json.Unmarshal(reqestBody, &body)

		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte(err.Error()))
		}

		room := rooms[body.RoomId]

		delete(codes, room.Code)

		// Change room stage as prepare
	})

	log.Printf("Starting server, visit http://localhost:8000")

	if err := http.ListenAndServe(":8000", router); err != nil {
		log.Fatal(err)
	}
}
