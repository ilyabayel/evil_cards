<script lang="ts">
    import H5 from "../typography/h5.svelte";
    import P from "../typography/p.svelte";

    export let userName: string;
    export let avatarSrc: string = "";
    export let score: number = 0;
</script>

<div class="user-card">
    <div class="avatar-box">
        {#if avatarSrc}
            <img src="" alt="user-avatar" class="avatar" />
        {:else}
            <div class="avatar"><P>{userName.charAt(0)}</P></div>
        {/if}
    </div>
    <div class="info-box">
        <H5>{userName}</H5>
        <P>{score}</P>
    </div>
</div>

<style>
    .user-card {
        display: grid;
        grid-template-columns: 6rem auto;
        height: 6rem;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
    }

    .avatar-box {
        display: grid;
        place-items: center;
        width: 100%;
        height: 100%;
        padding: 0.8em;
        box-sizing: border-box;
    }

    .avatar {
        border-radius: 4px;
        background: var(--color-primary);
        width: 100%;
        height: 100%;
        display: grid;
        place-items: center;
    }

    .info-box {
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
</style>
