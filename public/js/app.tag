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
        <span class="pure-form-message-inline add-url-error">{ message }</span>
      </form>
    </div>
  </div>

  <script>
    this.url = null
    this.message = null

    updateUrlValue(e) {
      this.url = e.target.value
    }

    saveUrl(e) {
      e.preventDefault()
      this.message = null
      this.update()
      nanoajax.ajax({
        url:'/api/url',
        method: "PATCH",
        body: `url=${encodeURIComponent(this.url)}`,
      }, (code, res) => {
        if (code != 200){
          this.message = JSON.parse(res).errors.join(" ")
          this.update()
        }
      })
    }

    this.on("before-mount", () => {
      nanoajax.ajax({
        url:'/api/url',
      }, (code, res) => {
        console.log("getting url from server")
        this.url = JSON.parse(res).url
        this.update()
      })
    })

  </script>
</app>
