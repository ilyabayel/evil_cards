<script lang="ts">
    import { afterUpdate } from "svelte";
    import { cn } from "../../utils";

    export let onClose: (e: MouseEvent) => void;
    export let visible: boolean = false;
    export let closeLabel = "Close";

    let hiding = false;
    let hidden = true;

    afterUpdate(() => {
        if (!visible && !hidden) {
            hiding = true;
            setTimeout(() => {
                hiding = false;
                hidden = true;
            }, 250);
        }
        if (visible) {
            hidden = false;
        }
    });
</script>

<div class="wrapper">
    <div
        class={cn(
            "bottom-modal-background",
            ["visible", visible],
            ["hiding", hiding],
            ["hidden", hidden]
        )}
        on:click={onClose}
    />
    <div
        class={cn(
            "bottom-modal",
            ["visible", visible],
            ["hiding", hiding],
            ["hidden", hidden]
        )}
    >
        <button class="close-btn" on:click={onClose}>
            <span>{closeLabel}</span>
        </button>
        <div class="body"><slot /></div>
    </div>
</div>

<style>
    .bottom-modal-background {
        pointer-events: none;
        top: 0;
        left: 0;
        position: fixed;
        width: 100vw;
        height: 100vh;
        opacity: 0;
    }

    .bottom-modal-background.visible {
        pointer-events: all;
        background-color: rgba(0, 0, 0, 0.6);
        animation: fadeInFromNone 0.2s ease;
        opacity: 1;
    }

    .bottom-modal-background.hiding {
        pointer-events: all;
        background-color: rgba(0, 0, 0, 0.6);
        animation: fadeOutToNone 0.2s ease;
        opacity: 0;
    }

    .bottom-modal-background.hidden {
        opacity: 0;
    }

    .bottom-modal {
        --local-max-height: 60vh;
        position: fixed;
        bottom: 0;
        transform: translateY(100%);
        left: 0;
        width: 100%;
        height: min-content;
        min-height: 20vh;
        max-height: var(--local-max-height);
        padding: 2em 2em 3em 2em;
        background-color: #727272;
        box-sizing: border-box;
        border-radius: 2em 2em 0 0;
    }
    .bottom-modal.visible {
        animation: SlideIn ease 0.15s;
        transform: translateY(0);
        opacity: 1;
    }

    .bottom-modal.hiding {
        animation: SlideOut ease 0.15s;
        transform: translateY(100%);
    }

    .bottom-modal.hidden {
        transform: translateY(100%);
        opacity: 0;
    }

    .close-btn {
        position: absolute;
        display: flex;
        align-items: center;
        justify-content: center;
        top: -1.8em;
        right: 1em;
        border: none;
        background: none;
        cursor: pointer;
        margin: 0;
        padding: 0;
    }

    .close-btn span {
        font-weight: 500;
        color: white;
        font-size: 1.6rem;
        margin-right: 1rem;
    }

    .body {
        width: 100%;
        height: min-content;
        max-height: calc(var(--local-max-height) - 5em);
        overflow: auto;
    }

    @keyframes SlideIn {
        from {
            transform: translateY(100%);
        }
        to {
            transform: translateY(0);
        }
    }

    @keyframes SlideOut {
        from {
            transform: translateY(0);
        }

        to {
            transform: translateY(100%);
        }
    }

    @keyframes fadeInFromNone {
        0% {
            display: none;
            opacity: 0;
        }

        1% {
            display: block;
            opacity: 0;
        }

        100% {
            display: block;
            opacity: 1;
        }
    }

    @keyframes fadeOutToNone {
        0% {
            display: block;
            opacity: 1;
        }

        99% {
            display: block;
            opacity: 0;
        }

        100% {
            display: none;
            opacity: 0;
        }
    }
</style>
