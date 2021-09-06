<script lang="ts">
    import { cn } from "../../utils";

    export let onClose: (e: MouseEvent) => void;
    export let visible: boolean = false;

    let hiding = false;

    $: {
        if (!visible) {
            hiding = true;
            setTimeout(() => {
                hiding = false;
            }, 250);
        }
    }
</script>

<div
    class={cn(
        "bottom-modal-background",
        ["visible", visible],
        ["hiding", hiding]
    )}
>
    <div class={cn("bottom-modal", ["visible", visible], ["hiding", hiding])}>
        <button class="close-btn" on:click={onClose}>
            <svg
                height="1.2em"
                viewBox="0 0 329.26933 329"
                width="1.2em"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    d="m194.800781 164.769531 128.210938-128.214843c8.34375-8.339844 8.34375-21.824219 0-30.164063-8.339844-8.339844-21.824219-8.339844-30.164063 0l-128.214844 128.214844-128.210937-128.214844c-8.34375-8.339844-21.824219-8.339844-30.164063 0-8.34375 8.339844-8.34375 21.824219 0 30.164063l128.210938 128.214843-128.210938 128.214844c-8.34375 8.339844-8.34375 21.824219 0 30.164063 4.15625 4.160156 9.621094 6.25 15.082032 6.25 5.460937 0 10.921875-2.089844 15.082031-6.25l128.210937-128.214844 128.214844 128.214844c4.160156 4.160156 9.621094 6.25 15.082032 6.25 5.460937 0 10.921874-2.089844 15.082031-6.25 8.34375-8.339844 8.34375-21.824219 0-30.164063zm0 0"
                />
            </svg>
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
        animation: fadeInFromNone 0.2s ease;
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

    .bottom-modal {
        position: fixed;
        bottom: 0;
        transform: translateY(100%);
        left: 0;
        width: 100%;
        height: min-content;
        max-height: 50vh;
        padding: 2em 2em 3em 2em;
        background-color: #727272;
        box-sizing: border-box;
        border-radius: 2em 2em 0 0;
    }
    .bottom-modal.visible {
        animation: SlideIn ease 0.15s;
        transform: translateY(0);
    }

    .bottom-modal.hiding {
        animation: SlideOut ease 0.15s;
        transform: translateY(100%);
    }

    .close-btn {
        position: absolute;
        top: 1.4em;
        right: 1.4em;
        border: none;
        background: none;
        cursor: pointer;
        padding: 0;
        margin: 0;
    }

    .close-btn svg path {
        fill: white;
    }

    .body {
        width: 100%;
        height: min-content;
        max-height: calc(50vh - 4em);
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
