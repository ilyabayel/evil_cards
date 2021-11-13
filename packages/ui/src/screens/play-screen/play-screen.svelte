<script lant="ts">
    import { RoomApi } from "src/api/socket";
    import { roomStore } from "src/store/room";
    import P from "../../components/typography/p.svelte";
    import { useNavigate } from "svelte-navigator";

    const roomId = localStorage.getItem("room_id");
    const navigate = useNavigate();

    if (!roomId) {
        navigate("/")
    }

    const api = new RoomApi(roomId);

    api.onRoomUpdate(res => roomStore.set(res));
    api.join().then((roomInfo) => roomStore.set(roomInfo));
</script>

<div class="play-screen">
    play page
    <P color="white">{JSON.stringify($roomStore)}</P>
</div>

<style>
    .play-screen {
    }
</style>
