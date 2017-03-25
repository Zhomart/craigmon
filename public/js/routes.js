(function(win){
  var main, app;

  function routeItems(){
    main.update({view: "items"})

    nanoajax.ajax({
      url:'/api/url',
    }, (code, res) => {
      url = JSON.parse(res).url
      app.trigger("url", url);
    });

    var params = new URLSearchParams(window.location.search);
    var page = params.get("page") || 1;
    nanoajax.ajax({
      url:'/api/items?page=' + page,
    }, (code, res) => {
      let result = JSON.parse(res);
      app.trigger("items", result.items, parseInt(page), result.pages);
    });

    app.trigger("view-items");
  }

  function routeNotFound(){
    main.update({view: "404"})
  }

  win.setupRoutes = function(_app, _main){
    app = _app;
    main = _main;

    route("/", routeItems);
    route("/items", routeItems);
    route("/items?page=*", routeItems);
    route("/..", routeNotFound);
  }
})(window);
