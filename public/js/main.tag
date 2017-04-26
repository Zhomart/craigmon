<main>

  <View-404 if={ view == "404" }/>
  <View-Item if={ view == "item" } app={ opts.app } data={ viewData }/>
  <View-Items if={ view == "items" } app={ opts.app } data={ viewData }/>
  <View-Searches if={ view == "searches" } app={ opts.app } data={ viewData }/>

  <script>
    this.view = null;
    this.viewData = null;
  </script>
</main>
