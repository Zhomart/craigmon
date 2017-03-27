(function(win){
  var main, app;

  function routeSearches(){
    main.update({view: "searches"})
  }

  function routeSearchItems(searchId){
    main.update({view: "items"})
  }

  function routeSearchItem(searchId, itemId){
    main.update({view: "item"})
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
