<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import H1 from "./h1.svelte";
    import H2 from "./h2.svelte";
    import H3 from "./h3.svelte";
    import H4 from "./h4.svelte";
    import H5 from "./h5.svelte";
    import H6 from "./h6.svelte";
    import P from "./p.svelte";
</script>

<Meta title="Typography" component={H1} subcomponents={{ H2, H3, H4, H5, P }} />

<Story name="Default">
    <H1>Heading 1</H1>
    <H2>Heading 2</H2>
    <H3>Heading 3</H3>
    <H4>Heading 4</H4>
    <H5>Heading 5</H5>
    <H6>Heading 6</H6>
    <P>Paragraph</P>
</Story>
