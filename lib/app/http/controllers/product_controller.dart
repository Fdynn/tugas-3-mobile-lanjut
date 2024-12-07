// ignore_for_file: implementation_imports

import 'package:vania/vania.dart';
import 'package:vania_api/app/models/product.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create(Request request) async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'name': 'required|string|max_length:100',
        'description': 'required|string|max_length:255',
        'price': 'required|number|min:0'
      }, {
        'name.required': 'Nama produk wajib diisi.',
        'name.string': 'Nama produk harus berupa teks.',
        'name.max_length': 'Nama produk maksimal 100 karakter.',
        'description.required': 'Deskripsi produk wajib diisi.',
        'description.string': 'Deskripsi produk harus berupa teks.',
        'description.max_length': 'Deskripsi produk maksimal 255 karakter.',
        'price.required': 'Harga produk wajib diisi.',
        'price.numeric': 'Harga produk harus berupa angka.',
        'price.min': 'Harga produk tidak boleh kurang dari 0.'
      });

      final productData = request.input();

      final existingProduct = await Product()
          .query()
          .where('name', '=', productData['name'])
          .first();

      if (existingProduct != null) {
        return Response.json(
            {'message': 'Produk dengan nama ini sudah ada.'}, 400);
      }

      productData['created_at'] = DateTime.now().toIso8601String();
      await Product().query().insert(productData);

      return Response.json({
        'message': 'Produk berhasil ditambahkan.',
        'data': productData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        }, 500);
      }
    }
  }

  Future<Response> show() async {
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

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'name': 'required|string|max_length:100',
        'description': 'required|string|max_length:255',
        'price': 'required|number|min:0'
      }, {
        'name.required': 'Nama produk wajib diisi.',
        'name.string': 'Nama produk harus berupa teks.',
        'name.max_length': 'Nama produk maksimal 100 karakter.',
        'description.required': 'Deskripsi produk wajib diisi.',
        'description.string': 'Deskripsi produk harus berupa teks.',
        'description.max_length': 'Deskripsi produk maksimal 255 karakter.',
        'price.required': 'Harga produk wajib diisi.',
        'price.numeric': 'Harga produk harus berupa angka.',
        'price.min': 'Harga produk tidak boleh kurang dari 0.'
      });

      final productData = request.input();
      productData['updated_at'] = DateTime.now().toIso8601String();

      final product = await Product().query().where('id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Product().query().where('id', '=', id).update(productData);

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
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        }, 500);
      }
    }
  }

  Future<Response> destroy(int id) async {
    try {
      // Cari produk berdasarkan ID
      final product = await Product().query().where('id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      // Hapus produk
      await Product().query().where('id', '=', id).delete();

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
