import { make as PlayerList } from "./PlayerList.bs"

export default {
    title: "PlayerList",
    component: PlayerList,
    argTypes: {
        players: {
            type: 'array',
            defaultValue: []
        },
        leaderboard: {
            type: 'object',
            defaultValue: {}
        }
    }
}

export const Template = (args) => <PlayerList {...args} />;