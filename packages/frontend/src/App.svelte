<script lang="ts">
  import "./global-styles.css";
  import BottomModal from "./components/bottom-modal/bottom-modal.svelte";
  import P from "./components/typography/p.svelte";

  let visible = false;
</script>

<main>
  <button on:click={() => (visible = !visible)}>switch</button>
  <BottomModal
    {visible}
    onClose={() => {
      visible = false;
    }}><P>sjdkflsjdfk</P></BottomModal
  >
</main>
