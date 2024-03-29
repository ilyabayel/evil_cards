type user = {
  id: string,
  name: string,
}

type stage = [#wait | #prepare | #play | #vote | #result]

type roomStatus = [#play | #finished]

type question = {
  id: string,
  title: string,
  text: string,
}

type answerOption = {
  id: string,
  text: string,
}

type answer = {
  question: question,
  options: array<answerOption>,
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
  options: array<answerOption>,
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
  options: Js.Dict.t<array<answerOption>>,
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
  players: [],
  round: {
    number: 0,
    leader: {
      id: "",
      name: "",
    },
    winner: {
      question: {
        id: "",
        title: "",
        text: "",
      },
      options: [],
      player: {
        id: "",
        name: "",
      },
    },
    question: {
      id: "",
      title: "",
      text: "",
    },
    answers: [],
    current_stage: #wait,
  },
  questions: [],
  leaderboard: Js.Dict.empty(),
  options: Js.Dict.empty(),
  code: 0,
  status: #play,
}

let testRoom = {
  id: "room",
  host: {
    id: "1",
    name: "First player",
  },
  round_duration: 60,
  rounds_per_player: 3,
  players: [
    {
      id: "1",
      name: "First player",
    },
    {
      id: "2",
      name: "Second player",
    },
    {
      id: "3",
      name: "Third player",
    },
    {
      id: "4",
      name: "Fourth player",
    },
    {
      id: "5",
      name: "Fifth player",
    },
    {
      id: "6",
      name: "Sixth player",
    },
    {
      id: "7",
      name: "Seventh player",
    },
    {
      id: "8",
      name: "Eighth player",
    },
  ],
  round: {
    number: 0,
    leader: {
      id: "1",
      name: "First player",
    },
    winner: {
      question: {
        id: "",
        text: "",
        title: "",
      },
      options: [],
      player: {
        id: "",
        name: "",
      },
    },
    question: {
      id: "q1",
      text: "Question one {_} end",
      title: "Question #1",
    },
    answers: [],
    current_stage: #wait,
  },
  questions: [],
  leaderboard: Js.Dict.fromArray([
    ("1", 1),
    ("2", 1),
    ("3", 1),
    ("4", 1),
    ("5", 1),
    ("6", 0),
    ("7", 1),
    ("8", 3),
  ]),
  options: Js.Dict.fromArray([
    ("1", []),
    ("2", []),
    ("3", []),
    ("4", []),
    ("5", []),
    ("6", []),
    ("7", []),
    ("8", []),
  ]),
  code: 1337,
  status: #play,
}
