<script lang="ts">
    export let label: string;
    export let onClick: (event: MouseEvent) => void;
    export let type: "primary" | "secondary" = "primary";
</script>

<button on:click={onClick} class={type}>{label}</button>

<style>
    button {
        padding: 0.8em 1.6em;
        border: none;
        border-radius: 0.6em;
        cursor: pointer;
        background: rgb(41, 111, 151);
        color: var(--color-font-primary);
        transition: box-shadow 0.2s;
        box-shadow: 0 0 0 rgba(0, 0, 0, 0.2);
        text-shadow: 0 0 2px black;
        font-size: 1.8rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
    }
    button:active {
        opacity: 0.85;
    }
    button.primary {
        background: var(--color-primary);
    }
    button.secondary {
        background: var(--color-secondary);
    }
</style>
