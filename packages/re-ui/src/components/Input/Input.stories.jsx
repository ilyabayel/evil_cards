import React from "react"
import { make as Input } from "./Input.bs"

export default {
    title: "Input",
    component: Input,
    argTypes: {
        children: {
            control: 'text'
        }
    }
}

export const Template = (args) => <Input {...args} />;