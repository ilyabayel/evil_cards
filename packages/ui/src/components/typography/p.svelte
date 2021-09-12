<script lang="ts">
    export let color: string = "";
    export let className = "";
</script>

<p class={className} style={color ? `--color-font-primary: ${color}` : ""}>
    <slot />
</p>

<style>
    p {
        color: var(--color-font-primary);
        font-size: 1.6rem;
        font-weight: 400;
        margin: 0;
    }
</style>
