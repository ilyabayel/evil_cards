<script lang="ts">
    import H6 from "../typography/h6.svelte";
    import type { Option } from "../../models/option";

    export let heading: string = "";
    export let body: Array<string | Option> = [];
</script>

<div class="result-card">
    <H6 color="black">{heading}</H6>
    <br />
    <p class="result-text-box">
        {#if body.length === 1}
            <span class="result-text">{body[0]}</span>
        {:else}
            {#each body as part, i}
                {#if typeof part === "string"}
                    <span class="result-text">
                        {part}
                    </span>
                {:else}
                    <span class="result-option-part">
                        {part.value}
                    </span>
                {/if}
            {/each}
        {/if}
    </p>
</div>

<style>
    .result-card {
        position: relative;
        background-color: #e0e0e0;
        padding: 2em;
        border-radius: 1.4em;
    }

    .result-text-box {
        word-wrap: break-word;
        line-height: 2.4em;
    }

    .result-text {
        font-size: 1.6em;
        color: black;
    }

    .result-option-part {
        display: inline-block;
        padding: 0 0.5em;
        background-color: rgba(255, 255, 255, 0.9);
        color: transparent;
        border-radius: 4px;
        font-size: 1.6rem;
        font-weight: 500;
    }
</style>
