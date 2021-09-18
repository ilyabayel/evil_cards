package main

import "github.com/google/uuid"

type User struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type Answer struct {
	ID     string `json:"id"`
	Text   string `json:"text"`
	Player *User  `json:"player"`
}

type Question struct {
	ID              string `json:"id"`
	QuestionnaireID string `json:"questionnaireId"`
	Text            string `json:"text"`
}

type Round struct {
	Number   uint16    `json:"number"`
	Leader   *User     `json:"leader"`
	Question *Question `json:"question"`
	Answers  []*Answer `json:"answer"`
}

type Room struct {
	ID              string  `json:"id"`
	Host            *User   `json:"host"`
	Code            string  `json:"code"`
	Players         []*User `json:"players"`
	CurrentStage    string  `json:"currentStage"`
	Round           *Round  `json:"round"`
	QuestionnaireId string  `json:"questionnaireId"`
	RoundPerPlayer  int     `json:"roundPerPlayer"`
	RoundDuration   int     `json:"roundDuration"`
}

type CreateRoomProps struct {
	Username        string
	RoundsPerPlayer int
	RoundDuration   int
	Code            string
}

func CreateRoom(props *CreateRoomProps) *Room {
	room := &Room{
		ID: uuid.NewString(),
		Host: &User{
			ID:   uuid.NewString(),
			Name: props.Username,
		},
		Code:           props.Code,
		CurrentStage:   "",
		RoundPerPlayer: props.RoundsPerPlayer,
		RoundDuration:  props.RoundDuration,
	}

	return room
}
