import 'package:vania/vania.dart';
import 'package:vania_api/app/http/controllers/product_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix

    Router.basePrefix('api');

    Router.post("/product", productController.store);
    Router.get("/product", productController.show);
    Router.put("/product/{id}", productController.update);
    Router.delete("/product/{id}", productController.destroy);
  }
}
