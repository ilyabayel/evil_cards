<script lang="ts">
    export let className: string = "";
</script>

<h3 class={className}><slot /></h3>

<style>
    h3 {
        color: var(--color-font-primary);
        font-size: 2.5rem;
        font-weight: 500;
        margin: 0;
    }
</style>
