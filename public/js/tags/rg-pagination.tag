<rg-pagination>

  <div class="pagination is-centered">
    <a class="pagination-previous" onclick={ back }>‹</a>
    <a class="pagination-next" onclick={ forward }>›</a>
    <ul class="pagination-list">
      <li><a class="pagination-link" if={ opts.pagination.page > 2 } onclick={ first }>1</a></li>
      <li><span class="pagination-ellipsis" if={ opts.pagination.page > 2 }>&hellip;</span></li>
      <li><a class="pagination-link" onclick="{ back }" if="{ opts.pagination.page > 1 }">{ opts.pagination.page - 1 }</a></li>
      <li><a class="pagination-link is-current">{ opts.pagination.page }</a></li>
      <li><a class="pagination-link" onclick="{ forward }" if="{ opts.pagination.page < opts.pagination.pages }">{ opts.pagination.page + 1 }</a></li>
      <li><span class="pagination-ellipsis" if={ opts.pagination.page <= opts.pagination.pages - 2 }>&hellip;</span></li>
      <li><a class="pagination-link" if={ opts.pagination.page <= opts.pagination.pages - 2 } onclick={ last }>{ opts.pagination.pages }</a></li>
    </ul>
  </div>

  <script>
    this.on('update', () => {
      if (!opts.pagination) opts.pagination = {
        pages: 1,
        page: 1
      }
    })

    this.on('page', () => {
      const btns = this.root.querySelectorAll('button')
      for (let i = 0; i < btns.length; i++) {
        btns[i].blur()
      }
    })

    forward (e) {
      e.preventDefault()
      if (opts.pagination.page < opts.pagination.pages){
        opts.pagination.page++
        this.trigger('page', opts.pagination.page)
        if (opts.onpress) opts.onpress(opts.pagination.page);
      }
    }

    back (e) {
      e.preventDefault()
      if (1 < opts.pagination.page){
        opts.pagination.page--
        this.trigger('page', opts.pagination.page)
        if (opts.onpress) opts.onpress(opts.pagination.page);
      }
    }

    first (e) {
      e.preventDefault()
      opts.pagination.page = 1
      this.trigger('page', opts.pagination.page)
      if (opts.onpress) opts.onpress(opts.pagination.page);
    }

    last (e) {
      e.preventDefault()
      opts.pagination.page = opts.pagination.pages
      this.trigger('page', opts.pagination.page)
      if (opts.onpress) opts.onpress(opts.pagination.page);
    }

  </script>

</rg-pagination>
