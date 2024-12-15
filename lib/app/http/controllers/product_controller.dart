// ignore_for_file: implementation_imports

import 'package:vania/vania.dart';
import 'package:vania_api/app/models/product.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania_api/app/models/productnote.dart';
import 'package:vania_api/app/models/vendor.dart';
import 'package:vania_api/app/utils/generateId.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    try {
      final product = await Product().query().get();
      return Response.json({
        'message': 'Produk berhasil ditemukan.',
        'data': product,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Produk tidak ditemukan.',
      }, 404);
    }
  }

  Future<Response> create(Request request) async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      print('Data yang diterima: ${request.input()}');

      request.validate({
        'vend_id': 'required|string',
        'prod_name': 'required|string|max_length:100',
        'prod_price': 'required|int|min:0',
        'prod_desc': 'required|string|max_length:255'
      });

      final productData = request.input();
      productData['prod_id'] = generateId();

      final existingVendor = await Vendor()
          .query()
          .where('vend_id', '=', productData['vend_id'])
          .first();

      if (existingVendor == null) {
        return Response.json({'message': 'Vendor tidak ada.'}, 400);
      }

      await Product().query().insert(productData);

      return Response.json({
        'message': 'Produk berhasil ditambahkan.',
        'data': productData,
      }, 201);
    } catch (e) {
      print('Error: ${e}');
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

  Future<Response> show(Request request, String productId) async {
    try {
      final product =
          await Product().query().where('prod_id', '=', productId).first();
      return Response.json({
        'message': 'Produk berhasil ditemukan.',
        'data': product,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Produk tidak ditemukan.',
      }, 404);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'prod_name': 'required|string|max_length:100',
        'prod_desc': 'required|string|max_length:255',
        'prod_price': 'required|int|min:0'
      });

      final productData = request.input();

      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }
      productData.remove('id');

      await Productnote().query().where('prod_id', '=', id).delete();
      await Product().query().where('prod_id', '=', id).update(productData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': productData,
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
      // Cari produk berdasarkan ID
      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      // Hapus produk
      await Product().query().where('prod_id', '=', id).delete();

      return Response.json({
        'message': 'Produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus produk.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductController productController = ProductController();
