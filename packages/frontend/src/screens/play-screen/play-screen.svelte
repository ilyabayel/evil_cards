<script lant="ts">
    import 
    import { useParams } from "svelte-navigator";

    const params = useParams();

    console.log($params.roomId);

    const roomInfo = JSON.parse(localStorage.getItem(`room-${$params.roomId}`));

    console.log(roomInfo);
</script>

<div class="play-screen">
    {#if roomInfo.currentSatage === "prepare"}
        <PrepareStage {roomInfo} />
    {/if}
</div>

<style>
    .play-screen {
    }
</style>
