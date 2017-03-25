(function(win){
  var main, app;

  function routeSearches(){
    main.update({view: "searches"})
  }

  function routeSearchItems(searchId){
    main.update({view: "items"})

    var params = new URLSearchParams(window.location.search);
    var page = params.get("page") || 1;
    nanoajax.ajax({
      url:'/api/searches/' + searchId + '/items?page=' + page,
    }, (code, res) => {
      let result = JSON.parse(res);
      app.trigger("search-items", result.search, result.items, parseInt(page), result.pages);
    });
  }

  function routeNotFound(){
    main.update({view: "404"})
  }

  win.setupRoutes = function(_app, _main){
    app = _app;
    main = _main;

    route("/", routeSearches);
    route("/searches", routeSearches);
    route("/searches/*/items", routeSearchItems);
    route("/searches/*/items?page=*", routeSearchItems);
    route("/..", routeNotFound);
  }
})(window);
