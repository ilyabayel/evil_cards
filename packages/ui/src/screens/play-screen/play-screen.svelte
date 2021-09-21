<script lant="ts">
    import PrepareStage from "./stages/prepare-stage/prepare-stage.svelte";
    import { useParams } from "svelte-navigator";

    const params = useParams();

    console.log($params.roomId);

    const roomInfo = JSON.parse(localStorage.getItem(`room-${$params.roomId}`));

    console.log(roomInfo);
</script>

<div class="play-screen">
    {#if roomInfo.currentSatage === "prepare"}
        prepare
    {/if}
</div>

<style>
    .play-screen {
    }
</style>
