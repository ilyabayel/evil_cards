import React from "react"
import { make as BottomModal } from "./BottomModal.bs"

export default {
    title: "BottomModal",
    component: BottomModal,
    argTypes: {
        closeLabel: {
            control: "text"
        },
        onClose: {
            action: "close"
        },
        visible: {
            control: "boolean",
            defaultValue: false
        },
        children: {
            control: "text"
        }
    }
}

export const Template = (args) => <BottomModal {...args} />;