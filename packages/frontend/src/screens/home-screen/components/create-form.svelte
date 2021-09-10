<script lang="ts">
    import H4 from "../../../components/typography/h4.svelte";
    import Button from "../../../components/button/button.svelte";
    import Input from "../../../components/input/input.svelte";
    import H2 from "../../../components/typography/h2.svelte";
    import { useNavigate } from "svelte-navigator";

    let nickname = "";
    let roundDuration = "60";
    let roundsPerPlayer = "3";

    const navigate = useNavigate();
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
        onClick={() => {
            localStorage.setItem(
                "room-1234",
                JSON.stringify({
                    id: "1234",
                    host: {
                        id: "p1",
                        name: nickname,
                    },
                    roundDuration: Number(roundDuration),
                    roundsPerPlayer: Number(roundsPerPlayer),
                    players: [
                        { id: "p1", name: nickname, points: 0 },
                        { id: "p2", name: "Player 2", points: 0 },
                        { id: "p3", name: "Player 3", points: 0 },
                    ],
                    currentStage: "prepare",
                })
            );

            navigate("/play/1234");
        }}
        disabled={[nickname, roundDuration, roundsPerPlayer].some(
            (item) => !item
        )}
    />
</form>

<style>
</style>
