import React from "react"
import { make as Button } from "./button.bs"

export default {
    title: "Button",
    component: Button,
    argTypes: {
        label: {
            defaultValue: "Button",
            control: "text"
        },
        onClick: {
            action: "click"
        },
        className: {
            control: "text",
            defaultValue: ""
        },
        disabled: {
            type: "boolean",
            defaultValue: false
        },
    }
}

export const Template = (args) => <Button {...args} />;