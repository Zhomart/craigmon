<app>
  <h1 class="title">Craigslist Monitor</h1>

  <div class="pure-g">
    <div class="pure-u-1-3"></div>
    <div class="pure-u-1-3">
      <form class="pure-form add" onsubmit={ saveUrl }>
        <fieldset>
          <legend>Put craigslist search url here:</legend>
          <input onkeyup={ updateUrlValue } value={ url } type="text" placeholder="e.g. https://sfbay.craigslist.org/search/vga" class="add-url pure-u-3-4">
          <button class="pure-button pure-button-primary">Save</button>
        </fieldset>
      </form>
    </div>
  </div>

  <script>
    this.url = "https://sfbay.craigslist.org/search/vga"

    updateUrlValue(e) {
      this.url = e.target.value
    }

    saveUrl(e) {
      e.preventDefault()
      nanoajax.ajax({
        url:'/api/url',
        method: "PATCH"
      }, (code, res) => {
        console.log(code)
        console.log(res)
      })
    }

  </script>
</app>
