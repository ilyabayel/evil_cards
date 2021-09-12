<script lang="ts">
    import H6 from "../typography/h6.svelte";
    import type { Option } from "../../models/option";

    export let heading: string = "";
    export let roundLeader: string = "";
    export let body: Array<string | Option> = [];
</script>

<div class="question-card">
    <H6 color="black">{heading}</H6>
    <br />
    <p class="question-text-box">
        {#if body.length === 1}
            <span class="question-text">{body[0]}</span>
        {:else}
            {#each body as part, i}
                {#if typeof part === "string"}
                    <span class="question-text">
                        {part}
                    </span>
                {:else}
                    <span
                        class="option-text"
                        data-id={part.id ? part.id : `blank${i}`}
                        on:dragenter={(e) => console.log(e)}
                        on:dragend={(e) => console.log(e)}>{part.value}</span
                    >
                {/if}
            {/each}
        {/if}
    </p>
    <span class="round-leader">{roundLeader}</span>
</div>

<style>
    .question-card {
        position: relative;
        background-color: #e0e0e0;
        padding: 2em 2em 3em 2em;
        border-radius: 1.4em;
    }

    .question-text-box {
        word-wrap: break-word;
        line-height: 2.4em;
    }

    .question-text {
        font-size: 1.6em;
        color: black;
    }

    .option-text {
        display: inline-block;
        padding: 0 0.5em;
        background-color: rgba(255, 255, 255, 0.9);
        color: black;
        border-radius: 4px;
        font-size: 1.6em;
    }

    .option-text[data-id*="blank"] {
        color: transparent;
    }

    .round-leader {
        font-size: 12px;
        font-weight: 500;
        color: var(--color-primary);
        position: absolute;
        bottom: 1em;
        right: 2em;
    }
</style>
