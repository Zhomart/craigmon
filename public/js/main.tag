<main>
  <h1 class="title uk-heading-primary">Craigslist Monitor</h1>

  <View-404 if={ view == "404" }/>
  <View-Items if={ view == "items" } app={ opts.app }/>

  <script>
    this.view = null;
  </script>
</main>
