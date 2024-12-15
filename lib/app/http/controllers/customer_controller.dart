// ignore_for_file: implementation_imports

import 'package:vania/vania.dart';
import 'package:vania_api/app/models/customer.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania_api/app/utils/generateId.dart';

class CustomerController extends Controller {
  Future<Response> index() async {
    try {
      final customers = await Customer().query().get();
      return Response.json({
        'message': 'Produk berhasil ditemukan.',
        'data': customers,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Produk tidak ditemukan.',
      }, 404);
    }
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'string|max_length:50',
        'cust_city': 'string|max_length:20',
        'cust_state': 'string|max_length:5',
        'cust_zip': 'string|max_length:7',
        'cust_country': 'string|max_length:25',
        'cust_telp': 'string|max_length:15',
      }, {
        'cust_name.required': 'Nama customer wajib diisi.',
        'cust_name.string': 'Nama customer harus berupa teks.',
        'cust_name.max_length': 'Nama customer maksimal 50 karakter.',
      });

      final customerData = request.input();

      customerData['cust_id'] = generateId();

      // Simpan data customer ke database
      await Customer().query().insert(customerData);

      return Response.json({
        'message': 'Customer berhasil dibuat.',
        'data': customerData,
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

  Future<Response> show(String custId) async {
    try {
      print(custId);
      final customer =
          await Customer().query().where('cust_id', '=', custId).first();
      return Response.json({
        'message': 'Produk berhasil ditemukan.',
        'data': customer,
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

  Future<Response> update(Request request, String custId) async {
    try {
      request.validate({
        'cust_name': 'string|max_length:50',
        'cust_address': 'string|max_length:50',
        'cust_city': 'string|max_length:20',
        'cust_state': 'string|max_length:5',
        'cust_zip': 'string|max_length:7',
        'cust_country': 'string|max_length:25',
        'cust_telp': 'string|max_length:15',
      }, {
        'cust_name.string': 'Nama customer harus berupa teks.',
        'cust_name.max_length': 'Nama customer maksimal 50 karakter.',
      });

      final customerData = request.input();

      // Ensure you're using the correct column name to query the customer
      final customer =
          await Customer().query().where('cust_id', '=', custId).first();

      if (customer == null) {
        return Response.json({
          'message': 'Customer dengan ID $custId tidak ditemukan.',
        }, 404);
      }
      customerData.remove('custid');
      await Customer()
          .query()
          .where('cust_id', '=', custId)
          .update(customerData);

      return Response.json({
        'message': 'Customer berhasil diperbarui.',
        'data': customerData,
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

  Future<Response> destroy(String custId) async {
    try {
      // Mencari customer berdasarkan cust_id
      final customer =
          await Customer().query().where('cust_id', '=', custId).first();

      if (customer == null) {
        return Response.json({
          'message': 'Customer dengan ID $custId tidak ditemukan.',
        }, 404);
      }

      // Menghapus customer
      await Customer().query().where('cust_id', '=', custId).delete();

      return Response.json({
        'message': 'Customer berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus customer.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final CustomerController customerController = CustomerController();
