<script lang="ts">
    import type { Option } from "../../models/option";
    import P from "../typography/p.svelte";

    export let body: Option;
    export let onClick: (e: MouseEvent) => void;
</script>

<button class="option-card" on:click={onClick}>
    <P>
        {body.value}
    </P>
</button>

<style>
    .option-card {
        background-color: rgba(255, 255, 255, 0.1);
        padding: 1em 1.5em;
        border-radius: 1em;
        cursor: pointer;
        border: 0;
        width: 100%;
        text-align: left;
    }
</style>
