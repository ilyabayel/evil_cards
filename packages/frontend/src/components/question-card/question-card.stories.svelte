<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import QuestionCard from "./question-card.svelte";
    import P from "../typography/p.svelte";
</script>

<Meta
    title="QuestionCard"
    component={QuestionCard}
    argTypes={{
        heading: { control: "text" },
        roundLeader: { control: "text" },
        body: { control: "text" },
    }}
/>

<Template let:args>
    <QuestionCard {...args} />
</Template>

<Story
    args={{
        heading: "Question 1",
        roundLeader: "Nickname",
        body: "Hello, {_}, I am your father. Hello, {_}, I am your father. Hello, {_}, I am your father",
    }}
    name="Default"
/>
