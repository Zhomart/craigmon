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

  <div class="items-container">
    <table class="pure-table pure-table-bordered">
      <thead>
        <tr>
          <th>Title</th>
          <th width="140px">Date</th>
          <th width="110px">Vanished</th>
          <th></th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr each={ items } class={ vanished: vanished_in }>
          <td>{ title }</td>
          <td>{ moment(date).format("MMM Do, H:mm") }</td>
          <td>{ vanished_in }</td>
          <td>{ comment ? "*" : "" }</td>
          <td><a href="{ link }" target="_blank"><i class="fa fa-external-link" aria-hidden="true"></i></a></td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="footer"></div>

  <script>
    this.url = null
    this.message = null
    this.items = []

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
        console.log("got url from server")
        this.url = JSON.parse(res).url
        this.update()
      })

      nanoajax.ajax({
        url:'/api/items',
      }, (code, res) => {
        console.log("got items from server")
        this.items = JSON.parse(res).items.map(item => {
          item.title = item.title.replace("&#x0024;", "$")
          item.date = new Date(item.date)
          item.issued = new Date(item.issued)
          item.created_at = new Date(item.created_at)
          item.updated_at = new Date(item.updated_at)
          item.vanished_at = item.vanished_at ? new Date(item.vanished_at) : null
          item.vanished_in = this.vanishedInCalc(item.vanished_at, item.date, item.created_at)
          return item
        })
        this.update()
      })
    })

    vanishedInCalc(vanished_at, date, created_at) {
      if (!vanished_at)
        return null;

      let initial_date = date < created_at ? date : created_at;
      var diff = (vanished_at - initial_date) / 60000;
      var measure = "mins";
      if (diff > 90) {
        diff = diff / 60;
        measure = "hours";
      }
      if (diff > 48) {
        diff = diff / 24;
        measure = "days";
      }
      diff = Math.round(diff * 10) / 10;

      return `in ${diff} ${measure}`;
    }

  </script>
</app>
