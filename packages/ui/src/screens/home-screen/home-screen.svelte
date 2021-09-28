<script lang="ts">
    import BottomModal from "../../components/bottom-modal/bottom-modal.svelte";
    import Button from "../../components/button/button.svelte";
    import H1 from "../../components/typography/h1.svelte";
    import H3 from "../../components/typography/h3.svelte";
    import CreateForm from "./components/create-form.svelte";

    let isCreateFormVisible = false;
    let isJoinFormVisible = false;

    function showCreateForm() {
        isJoinFormVisible = false;
        isCreateFormVisible = true;
    }

    function showJoinForm() {
        // isCreateFormVisible = false;
        // isJoinFormVisible = true;
    }
</script>

<div class="home-screen">
    <div class="title">
        <H1>Злобные карты</H1>
        <H3>Хорошая игра для плохих людей</H3>
    </div>
    <div class="buttons">
        <Button label="Создать игру" onClick={showCreateForm} />
        <Button label="Подключится к игре" onClick={showJoinForm} />
    </div>
    <BottomModal
        visible={isCreateFormVisible}
        onClose={() => (isCreateFormVisible = false)}
    >
        <CreateForm />
    </BottomModal>
    <BottomModal
        visible={isJoinFormVisible}
        onClose={() => (isJoinFormVisible = false)}
    >
        <div>join form</div>
    </BottomModal>
</div>

<style>
    .home-screen {
        width: 100%;
        height: 100%;
        display: grid;
        grid-template-rows: 1fr 1fr;
        grid-template-columns: 100%;
        place-items: center;
        text-align: center;
        padding: 1em;
        box-sizing: border-box;
    }

    .buttons {
        display: grid;
        gap: 1em 0;
    }
</style>
