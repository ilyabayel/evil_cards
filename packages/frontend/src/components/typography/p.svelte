<script lang="ts">
    export let color: string = "";
</script>

<p style={color ? `--color-font-primary: ${color}` : ""}><slot /></p>

<style>
    p {
        color: var(--color-font-primary);
        font-size: 1.8rem;
        font-weight: 400;
        margin: 0;
        text-shadow: 0 0 2px black;
    }
</style>
