<script lang="ts">
    import H6 from "../typography/h6.svelte";

    export let heading: string = "";
    export let roundLeader: string = "";
    export let body: string = "";

    const split = body.split("{_}");
</script>

<div class="question-card">
    <H6 color="black">{heading}</H6>
    <br />
    <p class="question-text-box">
        {#if split.length === 1}
            <span class="question-text">{split[0]}</span>
        {:else}
            {#each split as part, i}
                <span class="question-text">
                    {part}
                </span>
                {#if split.length - 1 !== i}
                    <span class="blank-space" data-id={i} />
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
        line-height: 2.2em;
    }

    .question-text {
        font-size: 1.6em;
        color: black;
    }

    .blank-space {
        display: inline-block;
        width: 8em;
        height: 2.2em;
        margin-bottom: -0.5em;
        background-color: rgba(255, 255, 255, 0.9);
        border-radius: 4px;
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
