<script lang="ts">
    export let color: string = "";
    export let className = "";
</script>

<h6 class={className} style={color && `--color-font-primary: ${color}`}>
    <slot />
</h6>

<style>
    h6 {
        color: var(--color-font-primary);
        font-size: 1.6rem;
        font-weight: 500;
        margin: 0;
    }
</style>
