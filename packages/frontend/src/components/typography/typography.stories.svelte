<script lang="ts">
    import { Meta, Template, Story } from "@storybook/addon-svelte-csf";
    import H1 from "./h1.svelte";
    import H2 from "./h2.svelte";
    import H3 from "./h3.svelte";
    import H4 from "./h4.svelte";
    import H5 from "./h5.svelte";
    import P from "./p.svelte";
</script>

<Meta title="Typography" component={H1} subcomponents={{ H2, H3, H4, H5, P }} />

<Story name="Default">
    <H1>Typography</H1>
    <H2>Typography</H2>
    <H3>Typography</H3>
    <H4>Typography</H4>
    <H5>Typography</H5>
    <P>Typography</P>
</Story>
