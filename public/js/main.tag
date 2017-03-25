<main>

  <View-404 if={ view == "404" }/>
  <View-Items if={ view == "items" } app={ opts.app }/>
  <View-Searches if={ view == "searches" } app={ opts.app }/>

  <script>
    this.view = null;
  </script>
</main>
