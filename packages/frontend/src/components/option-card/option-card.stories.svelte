<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import OptionCard from "./option-card.svelte";
    import { Option } from "../../models/option";
</script>

<Meta
    title="Option Card"
    component={OptionCard}
    argTypes={{
        body: { type: Option },
        onClick: { action: "onClick" },
    }}
/>

<Template let:args>
    <OptionCard {...args} />
</Template>

<Story
    args={{
        body: new Option("1", "some option"),
    }}
    name="Default"
/>
