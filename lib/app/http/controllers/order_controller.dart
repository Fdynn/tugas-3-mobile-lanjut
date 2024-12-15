import 'dart:math';

import 'package:vania/vania.dart';
import 'package:vania_api/app/models/order.dart';
import 'package:vania_api/app/models/order_item.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    try {
      final orders = await Order().query().get();
      return Response.json({
        'message': 'Orders berhasil ditemukan.',
        'data': orders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Orders tidak ditemukan.',
      }, 404);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
        'items': 'required|array',
      }, {
        'order_date.required': 'Tanggal order wajib diisi.',
        'cust_id.required': 'ID pelanggan wajib diisi.',
        'cust_id.string': 'ID pelanggan harus berupa teks.',
        'cust_id.max_length': 'ID pelanggan maksimal 5 karakter.',
        'items.required': 'Items wajib diisi.',
      });

      final orderData = request.input();
      final orderItems = orderData['items'];

      orderData['order_num'] =
          Random().nextInt(999999999).toString().padLeft(11, '0');
      orderData.remove('items');
      await Order().query().insert(orderData);

      for (var item in orderItems) {
        item['order_num'] = orderData['order_num'];
        item['order_item'] =
            Random().nextInt(999999999).toString().padLeft(11, '0');
        await OrderItem().query().insert(item);
      }

      print(orderData);

      return Response.json({
        'message': 'Order berhasil ditambahkan.',
        'data': orderData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'message':
              'Terjadi kesalahan di sisi server. Harap coba lagi nanti. $e',
        }, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    try {
      final order = await Order()
          .query()
          .join('orderitems', 'orderitems.order_num', '=', 'orders.order_num')
          .where('orders.order_num', '=', id)
          .first();
      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }
      return Response.json({
        'message': 'Order berhasil ditemukan.',
        'data': order,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server.',
      }, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'order_num': 'required|int',
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
        'items': 'array',
      }, {
        'order_num.required': 'Nomor order wajib diisi.',
        'order_date.required': 'Tanggal order wajib diisi.',
        'cust_id.required': 'ID pelanggan wajib diisi.',
        'cust_id.string': 'ID pelanggan harus berupa teks.',
        'cust_id.max_length': 'ID pelanggan maksimal 5 karakter.',
      });

      final orderData = request.input();
      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Order().query().where('order_num', '=', id).update(orderData);

      if (orderData.containsKey('items')) {
        await OrderItem().query().where('order_num', '=', id).delete();

        for (var item in orderData['items']) {
          item['order_num'] = id;
          await OrderItem().query().insert(item);
        }
      }

      return Response.json({
        'message': 'Order berhasil diperbarui.',
        'data': orderData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'message':
              'Terjadi kesalahan di sisi server. Harap coba lagi nanti. $e',
        }, 500);
      }
    }
  }

  Future<Response> destroy(String id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Order().query().where('order_num', '=', id).delete();
      await OrderItem().query().where('order_num', '=', id).delete();

      return Response.json({
        'message': 'Order berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus order.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderController orderController = OrderController();
