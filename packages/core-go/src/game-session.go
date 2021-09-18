package main

import (
	"log"

	"github.com/centrifugal/centrifuge"
)

type Event struct {
	roomId    string
	eventType string
}

func handleGameSession(room *Room, c chan Event, node *centrifuge.Node) {
	for event := range c {
		if event.roomId == room.ID {
			log.Println(room)
		}
	}
}
