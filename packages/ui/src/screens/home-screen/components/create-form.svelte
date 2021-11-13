<script lang="ts">
    import H4 from "../../../components/typography/h4.svelte";
    import Button from "../../../components/button/button.svelte";
    import Input from "../../../components/input/input.svelte";
    import H2 from "../../../components/typography/h2.svelte";
    import { useNavigate } from "svelte-navigator";
    import { v4 as uuid } from "uuid";
    import { LobbyApi } from "../../../api/socket";

    let nickname = "";
    let roundDuration = "60";
    let roundsPerPlayer = "3";

    const navigate = useNavigate();

    function handleCreate() {
        LobbyApi
        .createRoom({ id: uuid(), name: nickname })
        .then(res => {
            localStorage.setItem("room_id", res);
            navigate(`/play`);
        })
        .catch(err => console.log(err))        ;
    }
</script>

<form class="create-form" on:submit={(e) => e.preventDefault()}>
    <H2>Новая игра</H2>
    <Input onChange={(value) => (nickname = value)} value={nickname} />
    <H4>Настройка раундов</H4>
    <div>
        <Input
            onChange={(value) => (roundDuration = value)}
            value={roundDuration}
            type="number"
        />
        <Input
            onChange={(value) => (roundsPerPlayer = value)}
            value={roundsPerPlayer}
            type="number"
        />
    </div>
    <Button
        label="Создать"
        onClick={handleCreate}
        disabled={[nickname, roundDuration, roundsPerPlayer].some(
            (item) => !item
        )}
    />
</form>

<style>
</style>
