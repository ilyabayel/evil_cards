<script lang="ts">
    import { Meta, Story } from "@storybook/addon-svelte-csf";
    import BottomModal from "./bottom-modal.svelte";
    import H4 from "../typography/h4.svelte";
    import P from "../typography/p.svelte";
</script>

<Meta
    title="Bottom Modal"
    component={BottomModal}
    argTypes={{
        onClose: { action: "onClose" },
        visible: { type: "boolean", defaultValue: true },
        closeLabel: { type: "text", defaultValue: "Закрыть" },
    }}
/>

<!-- In Project it works fine but in storybook animations sucks -->
<Story name="Default" let:args>
    <H4>sdkfjalsdjfla;sdf</H4>
    <P>sadjkfl;asjdklasdf</P>
    <BottomModal {...args}>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
        <H4>Heading</H4>
        <P>Paragraph</P>
    </BottomModal>
</Story>
