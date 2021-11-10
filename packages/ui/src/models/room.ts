type ID = string;

export interface I_User {
    id: ID;
    name: string;
}

enum StageEnum {
    wait = "wait",
    prepare = "prepare",
    play = "play",
    vote = "vote",
    result = "result"
}

enum StatusEnum {
    play = "play",
    finished = "finished"
}

export interface I_Answer {
    question: I_Question;
    option: I_Option;
    player: I_User;
}

export interface I_Round {
    number: number;
    leader: I_User;
    winner: I_Answer;
    question: I_Question;
    answers: I_Answer[];
    current_stage: StageEnum;
}

export interface I_Question {
    id: ID;
    text: string;
}

export interface I_Option {
    id: ID;
    text: string;
}

export interface I_Questionnaire {
    id: ID;
    name: string;
    author: ID;
    questions: I_Question[];
    options: I_Option[];
}

export interface I_Leaderboard {
    [userId: string]: number;
}

export interface I_RoomInfo {
    id: string;
    host: I_User;
    round_duration: number;
    rounds_per_player: number;
    players: I_User[];
    round: I_Round;
    questions: I_Question[];
    leaderboard: I_Leaderboard;
    code: number;
    status: StatusEnum;
}