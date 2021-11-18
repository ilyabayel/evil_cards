import React from "react"
import { make as OptionCard } from "./OptionCard.bs"

export default {
    title: "OptionCard",
    component: OptionCard,
    argTypes: {
        option: {
            type: "object",
            defaultValue: {
                id: "id",
                text: "option"
            }
        },
        onClick: {
            action: 'click'
        },
        isSelected: {
            type: "boolean",
            defaultValue: false
        }
    }
}

export const Template = (args) => <OptionCard {...args} />;