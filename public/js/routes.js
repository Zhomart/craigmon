(function(win){
  var main, app;

  function routeSearches(){
    nanoajax.ajax({
      url:'/api/searches',
    }, (code, res) => {
      main.update({view: "searches", viewData: { result: JSON.parse(res) }})
    });
  }

  function routeSearchItems(searchId, page){
    if (!page) page = 1;
    nanoajax.ajax({
      url: '/api/searches/' + searchId + '/items?page=' + page,
    }, (code, res) => {
      let result = JSON.parse(res);
      main.update({view: "items", viewData: { result: result }})
    });
  }

  function routeSearchItem(searchId, itemId){
    var params = new URLSearchParams(window.location.search);
    var parts = window.location.href.split("/");
    var searchId = parts[parts.indexOf("searches") + 1];
    var itemId = parts[parts.indexOf("items") + 1];
    nanoajax.ajax({
      url: '/api/searches/' + searchId + '/items/' + itemId,
    }, (code, res) => {
      let result = JSON.parse(res);
      main.update({view: "item", viewData: {result: result}})
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
    route("/searches/*/items/*", routeSearchItem);
    route("/..", routeNotFound);
  }
})(window);
