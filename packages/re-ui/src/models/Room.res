type user = {
  id: string,
  name: string,
}

type stage = [#wait | #prepare | #play | #vote | #result]

type roomStatus = [#play | #finished]

type question = {
  id: string,
  text: string,
}

type option = {
  id: string,
  text: string,
}

type answer = {
  question: question,
  option: option,
  player: user,
}

type round = {
  number: int,
  leader: user,
  winner: answer,
  question: question,
  answers: array<answer>,
  current_stage: stage,
}

type questionnaire = {
  id: string,
  name: string,
  author: string,
  questions: array<question>,
  options: array<option>,
}

type leaderboard = Js.Dict.t<int>

type t = {
  id: string,
  host: user,
  round_duration: int,
  rounds_per_player: int,
  players: array<user>,
  round: round,
  questions: array<question>,
  leaderboard: leaderboard,
  code: int,
  status: roomStatus,
}

let empty = {
  id: "",
  host: {
    id: "",
    name: "",
  },
  round_duration: 0,
  rounds_per_player: 0,
  players: [
    {
      id: "1",
      name: "1",
    },
    {
      id: "2",
      name: "2",
    },
    {
      id: "3",
      name: "3",
    },
    {
      id: "4",
      name: "4",
    },
    {
      id: "5",
      name: "5",
    },
    {
      id: "6",
      name: "6",
    },
    {
      id: "7",
      name: "7",
    },
    {
      id: "8",
      name: "8",
    },
    {
      id: "9",
      name: "9",
    },
    {
      id: "0",
      name: "0",
    },
    {
      id: "01",
      name: "01",
    }
  ],
  round: {
    number: 0,
    leader: {
      id: "",
      name: "",
    },
    winner: {
      question: {
        id: "",
        text: "",
      },
      option: {
        id: "",
        text: "",
      },
      player: {
        id: "",
        name: "",
      },
    },
    question: {
      id: "",
      text: "",
    },
    answers: [],
    current_stage: #wait,
  },
  questions: [],
  leaderboard: Js.Dict.empty(),
  code: 0,
  status: #play,
}
