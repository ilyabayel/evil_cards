<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import QuestionCard from "./question-card.svelte";
    import { EmptyOption } from "../../models/option";
</script>

<Meta
    title="Question Card"
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
        body: ["Hello,", new EmptyOption(), ", I am your father."],
    }}
    name="Default"
/>
