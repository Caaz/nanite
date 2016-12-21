part of nanite;

class Nanite {
  List<Route> _routes = new List<Route>();
  String temporaryDir;
  Nanite(this.temporaryDir);
  listen(String host, int port) {
    HttpServer.bind(host, port).then((server) {
      server.listen((HttpRequest req) {
        bool handled = false;
        for(Route route in _routes) {
          List<Match> matches = route.uriPattern.allMatches(req.uri.toString());
          if(matches.length > 0) {
            route.action(new Nani(req,matches,new Renderer(req, temporaryDir)));
            handled = true;
            break;
          }
        }
        if(!handled) {
          print('Unhandled request: ${req.uri.toString()}');
          req.response.statusCode = 404;
          req.response.write('File Not found\n');
          req.response.close();
        }
      });
    });
  }
  addRoute(Route route) => _routes.add(route);
}
class Nani {
  HttpRequest request;
  List<Match> uriMatches;
  Renderer render;
  Nani(this.request, this.uriMatches, this.render);
}
class Route {
  RegExp uriPattern;
  Function action;
  Route(uri, this.action) {
    if(uri is RegExp) uriPattern = uri;
    else uriPattern = new RegExp('^${uri.toString()}\$');
  }
}
