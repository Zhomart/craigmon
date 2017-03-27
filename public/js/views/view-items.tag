<View-Items>
  <div class="container">
    <h1 class="title uk-heading-primary">Craigslist Monitor</h1>

    <a href="/searches">Back</a>

    <div class="search" if={ search }>
      <p><b>Name:</b> { search.name }</p>
      <p><b>URL:</b> <a href="{ search.url }" target="_blank">{ search.url }</a></p>
      <p><b>Crawled at:</b> { search.crawled_at ? moment(search.crawled_at).format("MMM Do, H:mm") : "not crawled" }</p>
    </div>

    <div class="pagination-container">
      <rg-pagination onpress={ openPage } pagination={ pagination } />
    </div>

    <div class="items-container">
      <table class="table">
        <thead>
          <tr>
            <th width="80px">Price</th>
            <th>Title</th>
            <th width="140px">Date</th>
            <th width="110px">Vanished</th>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each={ items } class={ vanished: vanished_in }>
            <td>${ price }</td>
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
    this.search = null
    this.items = []
    this.pagination = {pages: 0, page: 1}

    openPage(page, e) {
      var params = new URLSearchParams(window.location.search);
      var cpage = params.get("page") || 1;
      if (page != cpage)
        route("/searches/" + this.search.id + "/items?page=" + page);
    }

    opts.app.on("search-items", (search, items, page, pages) => {
      this.search = helperFixRecordDates(search, ["crawled_at"])
      this.items = items.map(_item => {
        item = helperFixRecordDates(_item, ["date", "issued", "vanished_at"])
        item.title = item.title.replace(/&#x0024;.+$/, "").trim()
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
