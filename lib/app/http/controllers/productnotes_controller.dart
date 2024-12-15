// ignore_for_file: implementation_imports

import 'package:vania/vania.dart';
import 'package:vania_api/app/models/productnote.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania_api/app/utils/generateId.dart';

class ProductnotesController extends Controller {
  Future<Response> index() async {
    final notes = await Productnote().query().get();
    return Response.json({
      'message': 'Catatan produk berhasil ditambahkan.',
      'data': notes,
    }, 201);
  }

  Future<Response> create(Request request) async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string'
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'note_date.required': 'Tanggal catatan wajib diisi.',
        'note_text.required': 'Teks catatan wajib diisi.',
      });

      final noteData = request.input();
      noteData['note_id'] = generateId();
      await Productnote().query().insert(noteData);

      return Response.json({
        'message': 'Catatan produk berhasil ditambahkan.',
        'data': noteData,
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
      final note =
          await Productnote().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({
          'message': 'Catatan dengan ID $id tidak ditemukan.',
        }, 404);
      }
      return Response.json({
        'message': 'Catatan berhasil ditemukan.',
        'data': note,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil catatan.',
      }, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string'
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'note_date.required': 'Tanggal catatan wajib diisi.',
        'note_text.required': 'Teks catatan wajib diisi.',
      });

      final noteData = request.input();

      final note =
          await Productnote().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({
          'message': 'Catatan dengan ID $id tidak ditemukan.',
        }, 404);
      }

      noteData.remove('id');

      await Productnote().query().where('note_id', '=', id).update(noteData);

      return Response.json({
        'message': 'Catatan berhasil diperbarui.',
        'data': noteData,
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
      final note =
          await Productnote().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({
          'message': 'Catatan dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Productnote().query().where('note_id', '=', id).delete();

      return Response.json({
        'message': 'Catatan berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus catatan.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductnotesController productnotesController = ProductnotesController();
