<script lang="ts">
  import { Router, Route } from "svelte-navigator";
  import Frame from "./components/frame/frame.svelte";
  import HomeScreen from "./screens/home-screen/home-screen.svelte";
  import PlayScreen from "./screens/play-screen/play-screen.svelte";
  import "./global-styles.css";
</script>

<main>
  <Frame>
    <Router>
      <Route path="/"><HomeScreen /></Route>
      <Route path="/play/:roomId"><PlayScreen /></Route>
    </Router>
  </Frame>
</main>
