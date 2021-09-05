<script lang="ts">
    export let color: string = "";
</script>

<h4 style={color && `--color-font-primary: ${color}`}><slot /></h4>

<style>
    h4 {
        color: var(--color-font-primary);
        font-size: 2.2rem;
        font-weight: 500;
        margin: 0;
    }
</style>
