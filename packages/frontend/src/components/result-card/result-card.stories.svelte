<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import ResultCard from "./result-card.svelte";
    import { EmptyOption } from "../../models/option";
</script>

<Meta
    title="Result Card"
    component={ResultCard}
    argTypes={{
        heading: { control: "text" },
        body: { control: "text" },
    }}
/>

<Template let:args>
    <ResultCard {...args} />
</Template>

<Story
    args={{
        heading: "Question 1",
        body: ["Hello, ", new EmptyOption(), ", I am your father."],
    }}
    name="Default"
/>
