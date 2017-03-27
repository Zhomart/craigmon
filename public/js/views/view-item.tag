<View-Item>
  <div class="container" style="width: 960px; padding-bottom: 64px;">
    <h1 class="title uk-heading-primary">Craigslist Monitor</h1>

    <a href="/searches/{ item.search_id }/items">Back</a>

    <div style="padding-top: 28px" if={ pictures.length > 0 }>
      <p><b><a href="{ item.link }" target="_blank">{ item.title } - ${ item.price }</a></b></p>
      <p><b>uid: </b>{ item.uid }</p>
      <p>Posted { moment(item.date).format("MMM Do, H:mm") }</p>
      <p if={ item.vanished_at }>Vanished at { moment(item.vanished_at).format("MMM Do, H:mm") } ({item.vanished_in})</p>
      <div class="gallery">
        <div class="gallery-screen">
          <img src="{ picture }" alt="">
        </div>
        <div class="gallery-list">
          <img each={ p in pictures } src="{ p }" alt="" onclick={ setCurrentPicture }>
        </div>
      </div>
    </div>

  </div>

  <script>
    this.mixin(Mixin)

    this.item = {}
    this.pictures = []
    this.picture = null

    this.on("mount", () => {
      var params = new URLSearchParams(window.location.search);
      var parts = window.location.href.split("/");
      var searchId = parts[parts.indexOf("searches") + 1];
      var itemId = parts[parts.indexOf("items") + 1];
      nanoajax.ajax({
        url: '/api/searches/' + searchId + '/items/' + itemId,
      }, (code, res) => {
        let result = JSON.parse(res);
        this.setItem(result.item)
      });
    })

    setItem(item) {
      this.item = this.mixinFixItem(item)
      this.pictures = new String([item.picture_urls]).split(", ")
      this.picture = this.pictures[0]
      this.update()
    }

    setCurrentPicture(e) {
      e.preventDefault()
      this.picture = e.item.p;
      this.update()
    }

  </script>

  <style>

    .gallery {
      width: 400px;
      margin-top: 24px;
      box-shadow: 10px 10px 10px #888;
    }

    .gallery:after {
      clear: both;
      content: " ";
      display: table;
    }

    .gallery-screen {
      width: 400px;
      padding-bottom: 8px;
    }

    .gallery-screen img {
      max-width: 400px;
    }

    .gallery-list {
    }

    .gallery-list img {
      width: 100px;
      display: block;
      float: left;
      padding: 1px;
      cursor: pointer;
    }

  </style>

</View-Item>
