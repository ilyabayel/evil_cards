import React from "react"
import { make as QuestionCard } from "./QuestionCard.bs"
import { body } from "./QuestionCardStories.bs"

export default {
    title: "QuestionCard",
    component: QuestionCard,
    argTypes: {
        heading: { control: "text", defaultValue: "Heading" },
        roundLeader: { control: "text", defaultValue: "Round Leader"  },
        body: { type: "array", defaultValue: body },
        selectedOption: { control: "text", defaultValue: ""},
        onSelect: { action: "Select" }
    }
}

export const Template = (args) => <QuestionCard {...args} />;