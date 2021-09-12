<script lang="ts">
    export let value: string;
    export let onChange: (value: string) => void;
    export let type: "text" | "number" = "text";
</script>

<input {type} {value} on:input={(e) => onChange(e.currentTarget.value)} />

<style>
    input {
        background: transparent;
        border: 2px solid rgba(255, 255, 255, 0.5);
        padding: 0.8em;
        border-radius: 6px;
        font-size: 1.6em;
        color: white;
        font-weight: 500;
    }
    input:focus {
        outline: none;
        background: rgba(255, 255, 255, 0.15);
    }
</style>
