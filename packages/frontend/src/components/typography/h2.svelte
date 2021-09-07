<script lang="ts">
    export let className: string = "";
</script>

<h2 class={className}><slot /></h2>

<style>
    h2 {
        color: var(--color-font-primary);
        font-size: 2.8rem;
        font-weight: 500;
        margin: 0;
    }
</style>
