function setupAppCallbacks(app) {

  app.on("openPage2", function(_page){
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
