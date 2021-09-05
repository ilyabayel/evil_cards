<script lang="ts">
    export let color: string = "";
</script>

<h6 style={color && `--color-font-primary: ${color}`}><slot /></h6>

<style>
    h6 {
        color: var(--color-font-primary);
        font-size: 1.6rem;
        font-weight: 500;
        margin: 0;
    }
</style>
