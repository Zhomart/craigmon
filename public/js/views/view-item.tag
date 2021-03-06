<View-Item>
  <div class="container" style="width: 960px; padding-bottom: 64px;">
    <h1 class="title uk-heading-primary">Craigslist Monitor</h1>

    <div class="columns">
      <div class="column">
        <a href="#" onClick={ goBack }>Back</a>

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
      <div class="column right-side">
        <div class="info">
          <div class="description">
            {item.description}
          </div>
          <div class="comment">
            <span if={ item.comment }>{item.comment}</span>
            <i if={ !item.comment }>no comments</i>
          </div>
        </div>
      </div>
    </div>

  </div>

  <script>
    this.mixin(Mixin)

    let result = this.opts.data.result;

    this.item = result.item
    this.pictures = new String([result.item.picture_urls]).split(", ")
    this.picture = this.pictures[0]

    goBack(e) {
      history.back()
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

    .right-side {
    }

    .info {
      padding-top: 70px;
    }

    .description {
      padding-bottom: 32px;
    }

    .comment {
      padding-top: 10px;
      border-top: 1px solid #999;
    }

  </style>

</View-Item>
