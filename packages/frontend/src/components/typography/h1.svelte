<script lang="ts">
    export let className: string = "";
</script>

<h1 class={className}><slot /></h1>

<style>
    h1 {
        color: var(--color-font-primary);
        font-size: 4.5rem;
        font-weight: 500;
        margin: 0;
    }
</style>
