<script lang="ts">
    export let color: string = "";
    export let className = "";
</script>

<h4 style={color && `--color-font-primary: ${color}`} class={className}>
    <slot />
</h4>

<style>
    h4 {
        color: var(--color-font-primary);
        font-size: 2.1rem;
        font-weight: 500;
        margin: 0;
    }
</style>
