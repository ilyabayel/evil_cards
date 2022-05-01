import { make as UserCard } from "./UserCard.bs"

export default {
    title: "UserCard",
    component: UserCard,
    argTypes: {
        userName: {
            control: 'text',
            defaultValue: 'userName'
        },
        avatar: {
            control: 'text',
            defaultValue: 'https://cdn.vox-cdn.com/thumbor/JgCPp2BBxETY596wCp50ccosCfE=/0x0:2370x1574/1200x800/filters:focal(996x598:1374x976)/cdn.vox-cdn.com/uploads/chorus_image/image/68870438/Screen_Shot_2020_07_21_at_9.38.25_AM.0.png'
        },
        score: {
            control: 'number',
            defaultValue: 100
        }
    }
}

export const Template = (args) => <UserCard {...args} />;