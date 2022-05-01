import React from "react"
import { make as ResultCard } from "./ResultCard.bs"
import { body } from "./ResultCardStories.bs"

export default {
    title: "ResultCard",
    component: ResultCard,
    argTypes: {
        heading: { control: "text", defaultValue: "Heading" },
        body: { type: "array", defaultValue: body },
    }
}

export const Template = (args) => <ResultCard {...args} />;