<View-Searches>
  <h1 class="title uk-heading-primary">Craigslist Monitor</h1>

  <div class="container">
    <button onclick={ newSearch } class="add-search-button button is-primary">Add</button>

    <div class="searches-container">
      <table class="table">
        <thead>
          <tr>
            <th width="20px"></th>
            <th>Name</th>
            <th>URL</th>
            <th width="110px">Date</th>
            <th width="110px">Crawled</th>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each={ searches } class={ disabled: !active }>
            <td><a href="#" class="" onclick= { parent.toggleActivity }>
              <i class={ "fa-check-square": active, "fa-square-o": !active, "fa": true } aria-hidden="true"></i>
            </a></td>
            <td><a href="/searches/{ id }/items">{ name }</a></td>
            <td><a href="{ url }" target="_blank">{ url }</a></td>
            <td>{ moment(created_at).format("MMM Do, H:mm") }</td>
            <td>{ crawled_at ? moment(crawled_at).format("MMM Do, H:mm") : "never" }</td>
            <td><a href="#" class="" onclick= { parent.editSearch }>Edit</a></td>
          </tr>
        </tbody>
      </table>
    </div>

  </div> <!-- .container -->

  <div class={ modal: true, "is-active": searchFormActive }>
    <div class="modal-background" onclick={ closeSearchForm }></div>
    <div class="modal-card">
      <form class="add" onsubmit={ searchFormSubmit }>
        <section class="modal-card-body">
          <div class="field is-horizontal">
            <div class="field-label is-normal">
              <label class="label">Name</label>
            </div>
            <div class="field-body">
              <div class="field">
                <div class="control">
                  <input onkeyup={ setSearchFormName } value={ searchForm.name } type="text"
                    class={ "is-danger": searchErrors.name, input: true }
                    placeholder="e.g. searching consoles">
                </div>
                <p class="help is-danger" if={ searchErrors.name }>{ searchErrors.name }</p>
              </div>
            </div>
          </div>
          <div class="field is-horizontal">
            <div class="field-label is-normal">
              <label class="label">URL</label>
            </div>
            <div class="field-body">
              <div class="field">
                <div class="control">
                  <input onkeyup={ setSearchFormURL } value={ searchForm.url } type="text"
                    class={ "is-danger": searchErrors.url, input: true }
                    placeholder="e.g. https://sfbay.craigslist.org/search/vga">
                </div>
                <p class="help is-danger" if={ searchErrors.url }>{ searchErrors.url }</p>
              </div>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button type="submit" class="button is-success">Save</button>
          <a class="button" onclick={ closeSearchForm }>Cancel</a>
        </footer>
      </form>
    </div>
    <button class="modal-close" onclick={ closeSearchForm }></button>
  </div>

  <script>
    this.searches = []
    this.searchFormActive = false
    this.searchForm = { name: null, url: null }
    this.searchErrors = { name: null, url: null }

    newSearch() {
      this.searchForm = { name: null, url: null }
      this.searchFormActive = true
    }

    editSearch(e) {
      e.preventDefault()
      this.searchForm = { name: e.item.name, url: e.item.url, id: e.item.id }
      this.searchFormActive = true
    }

    closeSearchForm(e) {
      if (e) e.preventDefault()
      this.searchFormActive = false
      this.searchErrors = {}
    }

    setSearchFormName(e) {
      this.searchForm.name = e.target.value
    }

    setSearchFormURL(e) {
      this.searchForm.url = e.target.value
    }

    // When user clicks on "Save" button on form
    searchFormSubmit(e) {
      e.preventDefault()
      this.searchErrors = {}
      search = { name: this.searchForm.name, url: this.searchForm.url }
      if (this.searchForm.id) {
        this.updateSearch(this.searchForm.id, search, (code, res) => {
          if (code == 200){
            this.closeSearchForm(null)
            this.update()
          } else {
            this.setFormErrors(JSON.parse(res).errors)
          }
        })
      } else {
        this.createSearch(search)
      }
    }

    // When user clicks on enable/disable checkbox
    toggleActivity(e) {
      e.preventDefault()
      this.updateSearch(e.item.id, { active: !e.item.active }, (code, res) => {
        if (code != 200)
          alert("cannot set active")
      })
    }

    setSearches(searches) {
      this.searches = searches.map(s => {
        s.crawled_at = s.crawled_at ? new Date(s.crawled_at) : null
        s.created_at = new Date(s.created_at)
        s.updated_at = new Date(s.updated_at)
        return s
      })
      this.closeSearchForm(null)
      this.update()
    }

    setFormErrors(errors) {
      errors.forEach(err => {
        this.searchErrors[err.field] = err.message;
      })
      this.update()
    }

    updateSearch(id, search, callback = undefined) {
      nanoajax.ajax({
        url:'/api/searches/' + id,
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(search)
      }, (code, res) => {
        if (code == 200) {
          var search = JSON.parse(res).search;
          var idx = this.searches.findIndex(s => s.id == search.id);
          this.searches[idx] = search;
          this.update()
        }
        if (callback) callback(code, res)
      })
    }

    createSearch(search, callback = undefined) {
      nanoajax.ajax({
        url: "/api/searches",
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(search)
      }, (code, res) => {
        if (code == 200){
          this.setSearches(JSON.parse(res).searches)
        } else {
          this.setFormErrors(JSON.parse(res).errors)
        }
        if (callback) callback(code, res);
      })
    }

    this.on("mount", () => {
      nanoajax.ajax({
        url:'/api/searches',
      }, (code, res) => {
        this.setSearches(JSON.parse(res).searches)
      });
    })
  </script>


  <style>
    .add-search-button {
      margin-bottom: 10px;
    }

    .container {
      width: 1200px;
    }

    .searches-container tr.disabled {
      color: lightgray;
    }

    .searches-container tr.disabled a {
      color: lightgray;
    }

  </style>
</View-Searches>
