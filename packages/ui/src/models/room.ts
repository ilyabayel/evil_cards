type ID = string;

export interface I_User {
    id: ID;
    name: string;
}

interface I_Player extends I_User {
    points: number;
}

enum StagesEnum {
    Wait,
    Prepare,
    Play,
    WinnerDetermination,
    Result
}

export interface I_Answer {
    question: I_Question;
    option: I_Option;
    player: I_Player;
}

export interface I_Round {
    number: number;
    leader: I_User;
    question: I_Question;
    answers: I_Answer[];
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
    [userId: string]: number
}

export interface I_RoomInfo {
    id: string;
    host: I_User;
    roundDuration: number;
    roundPerPlayer: number;
    players: I_Player[];
    currentStage: StagesEnum;
    round: I_Round;
    questionnaireId: ID;
    leaderboard: I_Leaderboard
}