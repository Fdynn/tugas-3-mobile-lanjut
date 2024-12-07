import 'package:vania/vania.dart';

class WebRoute implements Route {
  @override
  void register() {
    Router.get("/", () {
      return Response.json({
        'message': 'Hello, World!',
        'version': '1.0.0',
        'author': 'Vania',
        'license': 'MIT',
      });
    });
  }
}
