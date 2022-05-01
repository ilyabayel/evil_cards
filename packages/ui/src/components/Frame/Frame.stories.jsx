import React from "react"
import { make as Frame } from "./Frame.bs"

export default {
    title: "Frame",
    component: Frame,
    argTypes: {
        children: {
            control: 'text'
        }
    }
}

export const Template = (args) => <Frame {...args} />;