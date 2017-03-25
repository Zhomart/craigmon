<View-Items>

  <div class="container">

    <div class="columns">
      <div class="column"></div>
      <div class="column">
        <form class="add" onsubmit={ saveUrl }>
          <p>Put craigslist search url here:</p>
          <div class="field has-addons">
            <p class="control is-expanded">
              <input onkeyup={ updateUrlValue } value={ url } type="text"
                class={ "is-danger": message, input: true }
                placeholder="e.g. https://sfbay.craigslist.org/search/vga">
            </p>
            <p class="control">
              <button class="button is-info">
                Save
              </button>
            </p>
          </div>
          <p class="help is-danger">{ message }</p>
        </form>
      </div>
      <div class="column"></div>
    </div>

    <div class="pagination-container">
      <rg-pagination onpress={ openPage } pagination={ pagination } />
    </div>

    <div class="items-container">
      <table class="table">
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

    <div class="pagination-container">
      <rg-pagination onpress={ openPage } pagination={ pagination } />
    </div>
  </div>

  <script>
    this.url = null
    this.message = null
    this.items = []
    this.pagination = {pages: 0, page: 1}

    updateUrlValue(e) {
      this.url = e.target.value
    }

    saveUrl(e) {
      e.preventDefault()
      this.message = null
      this.update()
      this.opts.app.trigger("saveUrl", this.url);
    }

    openPage(page, e) {
      opts.app.trigger("openPage", page)
    }

    opts.app.on("url-error", (message) => {
      this.message = message
      this.update()
    })

    opts.app.on("url", (url) => {
      this.url = url
      this.update()
    })

    opts.app.on("items", (items, page, pages) => {
      this.items = items.map(item => {
        item.title = item.title.replace("&#x0024;", "$")
        item.date = new Date(item.date)
        item.issued = new Date(item.issued)
        item.created_at = new Date(item.created_at)
        item.updated_at = new Date(item.updated_at)
        item.vanished_at = item.vanished_at ? new Date(item.vanished_at) : null
        item.vanished_in = this.vanishedInCalc(item.vanished_at, item.date, item.created_at)
        return item
      })
      this.pagination = { page: page, pages: pages };
      this.update()
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
</View-Items>
