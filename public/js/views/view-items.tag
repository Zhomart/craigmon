<View-Items>
  <div class="container">
    <h1 class="title uk-heading-primary">Craigslist Monitor</h1>

    <a href="#" onClick={ goBack }>Back</a>

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
            <th width="164px">Date</th>
            <th width="280px">Gone</th>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each={ items } class={ vanished: vanished_in }>
            <td>${ price }</td>
            <td><a href="/searches/{ search.id }/items/{ id }">{ title }</a></td>
            <td>{ moment(date).format("MMM Do, H:mm") }</td>
            <td>
              <virtual if={ vanished_at }>
                { moment(vanished_at).format("MMM Do, H:mm") } ({ vanished_in })
              </virtual>
            </td>
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
    this.mixin(Mixin)

    let result = this.opts.data.result

    this.search = this.helperFixRecordDates(result.search, ["crawled_at"])
    this.items = result.items.map(_item => this.mixinFixItem(_item) )
    this.pagination = {pages: result.pages, page: result.page}

    goBack(e) {
      history.back()
    }

    openPage(page, e) {
      var params = new URLSearchParams(window.location.search);
      var cpage = params.get("page") || 1;
      if (page != cpage)
        route("/searches/" + this.search.id + "/items?page=" + page);
    }

  </script>
</View-Items>
