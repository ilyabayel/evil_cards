<script lang="ts">
    export let label: string;
    export let onClick: (event: MouseEvent) => void;
    export let type: "primary" | "secondary" = "primary";
    export let width: string = "auto";
    export let disabled = false;
</script>

<button
    style={`--local-width: ${width}`}
    on:click={onClick}
    class={type}
    {disabled}
>
    {label}
</button>

<style>
    button {
        padding: 0.8em 1.6em;
        border: none;
        border-radius: 0.6em;
        cursor: pointer;
        background: rgb(41, 111, 151);
        color: var(--color-font-primary);
        transition: box-shadow 0.2s;
        font-size: 1.6em;
        font-weight: 500;
        width: var(--local-width);
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
    button:disabled {
        opacity: 0.5;
    }
</style>
