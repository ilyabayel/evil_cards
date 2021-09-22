type ID = string;

interface I_User {
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

interface I_Answer {
    option: I_Option;
    player: I_Player;
}

interface I_Round {
    number: number;
    leader: I_User;
    question: I_Question;
    answers: I_Answer[];
}

interface I_Question {
    id: ID;
    text: string;
}

interface I_Option {
    id: ID;
    text: string;
}

interface I_Questionnaire {
    id: ID;
    name: string;
    author: ID;
    questions: I_Question[];
    options: I_Option[];
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
}