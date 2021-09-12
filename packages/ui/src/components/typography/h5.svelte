<script lang="ts">
    export let className: string = "";
</script>

<h5 class={className}><slot /></h5>

<style>
    h5 {
        color: var(--color-font-primary);
        font-size: 1.8rem;
        font-weight: 400;
        margin: 0;
    }
</style>
