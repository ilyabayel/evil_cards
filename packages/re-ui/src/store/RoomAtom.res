type user = {
    id: string,
    name: string,
}

type stage = [#wait | #prepare | #play | #vote | #result]

type roomStatus = [#play | #finished]

type question = {
    id: string,
    text: string
}


type option = {
    id: string,
    text: string,
}

type answer = {
    question: question,
    option: option,
    player: user
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

type leaderboard = Js.Dict.t<string>

type roomInfo = {
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
            name: ""
        },
        round_duration: 0,
        rounds_per_player: 0,
        players: [],
        round: {
            number: 0,
            leader: {
                id: "",
                name: ""
            },
            winner: {
                question: {
                    id: "",
                    text: "",
                },
                option: {
                    id: "",
                    text: ""
                },
                player: {
                    id: "",
                    name: ""
                }
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

let atom = Recoil.atom({
    key: "room",
    default: empty
})