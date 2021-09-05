<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import Input from "./input.svelte";
</script>

<Meta
    title="Input"
    component={Input}
    argTypes={{
        value: { control: "text" },
        onChange: { action: "onChange" },
        type: {
            type: "select",
            options: ["text", "number"],
            defaultValue: "text",
        },
    }}
/>

<Template let:args>
    <Input {...args} />
</Template>

<Story args={{ value: "Some value" }} name="Default" />
