// ignore_for_file: implementation_imports

import 'package:vania/vania.dart';
import 'package:vania_api/app/models/user.dart';
import 'package:vania/src/exception/validation_exception.dart';

class AuthController extends Controller {
  Future<Response> updatePassword(Request request) async {
    request.validate({
      'current_password': 'required',
      'password': 'required|min_length:6|confirmed',
    }, {
      'current_password.required': 'Password saat ini wajib diisi.',
      'password.required': 'Password baru wajib diisi.',
      'password.min_length': 'Password baru harus memiliki minimal 6 karakter.',
      'password.confirmed': 'Konfirmasi password tidak cocok.',
    });

    String currentPassword = request.string("current_password");
    Map<String, dynamic>? user = Auth().user();

    if (user != null) {
      // Perbaikan dari '=' menjadi '!='
      if (Hash().verify(currentPassword, user['password'])) {
        await User().query().where('id', '=', Auth().id()).update({
          // Perbaikan dari '-' menjadi '='
          'password': Hash().make(request.string("password")),
        });
        return Response.json({
          'status': 'success',
          'message': 'Password berhasil diperbarui',
        });
      } else {
        return Response.json({
          'status': 'error',
          'message': 'Password saat ini tidak cocok',
        }, 401);
      }
    } else {
      return Response.json({
        'status': 'error',
        'message': 'Pengguna tidak ditemukan',
      }, 404); // Perbaikan dari '484' menjadi '404'
    }
  }

  Future<Response> signUp(Request request) async {
    try {
      request.validate({
        'email': 'required|email',
        'password': 'required|string|min_length:6',
        'name': 'required|string|max_length:50',
      }, {
        'email.required': 'Email wajib diisi.',
        'email.email': 'Format email tidak valid.',
        'password.required': 'Password wajib diisi.',
        'password.min_length': 'Password minimal 6 karakter.',
        'name.required': 'Nama wajib diisi.',
        'name.max_length': 'Nama maksimal 50 karakter.',
      });

      final userData = request.input();
      userData['password'] =
          Hash().make(userData['password']); // Hash password sebelum disimpan

      // Simpan data pengguna ke database
      await User().query().insert(userData);

      return Response.json({
        'message': 'Pendaftaran berhasil.',
        'data': userData,
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

  Future<Response> signIn(Request request) async {
    // Retrieve user data from the model (provider)
    final Map<String, dynamic>? user = await User()
        .query()
        .where('email', '=', request.input('email'))
        .first();

// Check if user exists
    if (user == null) {
      return Response.json(
        {'message': 'User not found'},
        404,
      );
    }

// Check if the password matches
    if (!Hash()
        .verify(request.input('password'), user['password'].toString())) {
      return Response.json(
        {'message': 'Wrong password'},
        401,
      );
    }

// Authenticate the user and generate a token
    final Map<String, dynamic> token = await Auth()
        .login(user)
        .createToken(expiresIn: Duration(hours: 24), withRefreshToken: true);

// Further actions after successful authentication
// For example, returning the token
    return Response.json(token, 200);
  }
}

final AuthController authController = AuthController();
