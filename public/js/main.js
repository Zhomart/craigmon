ready(function() {
  route.base("/");

  var app = riot.observable(); // for event exchanging

  riot.compile(function() {
    // here tags are compiled and riot.mount works synchronously
    var main = riot.mount('main', { app: app })[0];
    setupRoutes(app, main);
    route.start(true);
  });

});
