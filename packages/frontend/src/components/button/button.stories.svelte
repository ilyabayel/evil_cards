<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import Button from "./button.svelte";
</script>

<Meta
    title="Button"
    component={Button}
    argTypes={{
        label: { control: "text" },
        onClick: { action: "onClick" },
        type: {
            type: "select",
            options: ["primary", "secondary"],
            defaultValue: "primary",
        },
    }}
/>

<Template let:args>
    <Button {...args} />
</Template>

<Story args={{ label: "label" }} name="Default" />
