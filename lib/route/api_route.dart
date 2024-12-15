import 'package:vania/vania.dart';
import 'package:vania_api/app/http/controllers/auth_controller.dart';
import 'package:vania_api/app/http/controllers/product_controller.dart';
import 'package:vania_api/app/http/controllers/customer_controller.dart';
import 'package:vania_api/app/http/controllers/vendor_controller.dart';
import 'package:vania_api/app/http/controllers/productnotes_controller.dart';
import 'package:vania_api/app/http/controllers/order_controller.dart';
import 'package:vania_api/app/http/middleware/authenticate.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix

    Router.basePrefix('api');

    Router.post("/signin", authController.signIn);
    Router.post("/signup", authController.signUp);

    Router.post("/product", productController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get("/product", productController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.get("/product/{id}", productController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put("/product/{id}", productController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete("/product/{id}", productController.destroy)
        .middleware([AuthenticateMiddleware()]);

    Router.get("/customer", customerController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post("/customer", customerController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get("/customer/{custId}", customerController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put("/customer/{custId}", customerController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete("/customer/{custId}", customerController.destroy)
        .middleware([AuthenticateMiddleware()]);

    Router.get("/vendor", vendorController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post("/vendor", vendorController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get("/vendor/{vendorId}", vendorController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put("/vendor/{vendorId}", vendorController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete("/vendor/{vendorId}", vendorController.destroy)
        .middleware([AuthenticateMiddleware()]);

    Router.get("/productnotes", productnotesController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post("/productnotes", productnotesController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get("/productnotes/{id}", productnotesController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put("/productnotes/{id}", productnotesController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete("/productnotes/{id}", productnotesController.destroy)
        .middleware([AuthenticateMiddleware()]);

    Router.get("/order", orderController.index)
        .middleware([AuthenticateMiddleware()]);
    Router.post("/order", orderController.store)
        .middleware([AuthenticateMiddleware()]);
    Router.get("/order/{id}", orderController.show)
        .middleware([AuthenticateMiddleware()]);
    Router.put("/order/{id}", orderController.update)
        .middleware([AuthenticateMiddleware()]);
    Router.delete("/order/{id}", orderController.destroy)
        .middleware([AuthenticateMiddleware()]);
  }
}
