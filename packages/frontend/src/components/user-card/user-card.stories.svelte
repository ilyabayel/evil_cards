<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import UserCard from "./user-card.svelte";
</script>

<Meta
    title="UserCard"
    component={UserCard}
    argTypes={{
        userName: { type: "text" },
        score: { type: "number" },
        avatar: { type: "text" },
    }}
/>

<Template let:args>
    <div
        style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem 1rem;"
    >
        <UserCard {...args} />
        <UserCard {...args} />
        <UserCard {...args} />
        <UserCard {...args} />
        <UserCard {...args} />
        <UserCard {...args} />
    </div>
</Template>

<Story args={{ userName: "Nickname", score: 0 }} name="Default" />
