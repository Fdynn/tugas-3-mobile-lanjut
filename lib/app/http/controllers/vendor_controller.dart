// ignore_for_file: implementation_imports

import 'package:vania/vania.dart';
import 'package:vania_api/app/models/vendor.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania_api/app/utils/generateId.dart';

class VendorController extends Controller {
  Future<Response> index() async {
    try {
      final vendors = await Vendor().query().get();
      return Response.json({
        'message': 'Vendor berhasil ditemukan.',
        'data': vendors,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Vendor tidak ditemukan.',
      }, 404);
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'vend_name': 'required|string|max_length:100',
        'vend_address': 'string|max_length:255',
        'vend_kota': 'string|max_length:50',
        'vend_state': 'string|max_length:50',
        'vend_zip': 'string|max_length:10',
        'vend_country': 'string|max_length:50',
      }, {
        'vend_name.required': 'Nama vendor wajib diisi.',
        'vend_name.string': 'Nama vendor harus berupa teks.',
        'vend_name.max_length': 'Nama vendor maksimal 100 karakter.',
      });

      final vendorData = request.input();
      vendorData['vend_id'] = generateId();

      await Vendor().query().insert(vendorData);

      return Response.json({
        'message': 'Vendor berhasil ditambahkan.',
        'data': vendorData,
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

  Future<Response> show(String id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan.',
        }, 404);
      }
      return Response.json({
        'message': 'Vendor berhasil ditemukan.',
        'data': vendor,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mencari vendor.',
      }, 500);
    }
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, String vendorId) async {
    try {
      request.validate({
        'vend_name': 'string|max_length:100',
        'vend_address': 'string|max_length:255',
        'vend_kota': 'string|max_length:50',
        'vend_state': 'string|max_length:50',
        'vend_zip': 'string|max_length:10',
        'vend_country': 'string|max_length:50',
      }, {
        'vend_name.string': 'Nama vendor harus berupa teks.',
        'vend_name.max_length': 'Nama vendor maksimal 100 karakter.',
      });

      final vendorData = request.input();

      final vendor =
          await Vendor().query().where('vend_id', '=', vendorId).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $vendorId tidak ditemukan.',
        }, 404);
      }
      vendorData['vend_id'] = vendorData.remove('vendorid');
      print(vendorData);
      await Vendor().query().where('vend_id', '=', vendorId).update(vendorData);

      return Response.json({
        'message': 'Vendor berhasil diperbarui.',
        'data': vendorData,
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
      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Vendor().query().where('vend_id', '=', id).delete();

      return Response.json({
        'message': 'Vendor berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus vendor.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final VendorController vendorController = VendorController();
