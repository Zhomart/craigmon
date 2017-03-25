function setupAppCallbacks(app) {
  app.on("saveUrl", function(url){
    nanoajax.ajax({
      url:'/api/url',
      method: "PATCH",
      body: `url=${encodeURIComponent(url)}`,
    }, (code, res) => {
      if (code != 200){
        let message = JSON.parse(res).errors.join(" ");
        app.trigger("url-error", message);
      }
    })
  });

  app.on("openPage", function(_page){
    var params = new URLSearchParams(window.location.search);
    var page = params.get("page") || 1;
    if (_page == page)
      return;
    route("/items?page=" + _page);
  });
}

ready(function() {
  route.base("/");

  var app = riot.observable(); // for event exchanging

  setupAppCallbacks(app);

  riot.compile(function() {
    // here tags are compiled and riot.mount works synchronously
    var main = riot.mount('main', { app: app })[0];
    setupRoutes(app, main);
    route.start(true);
  });
});
