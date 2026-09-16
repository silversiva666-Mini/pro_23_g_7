import 'package:dio/dio.dart';

import '../model/user_model.dart';

class AuthRepository {
  AuthRepository();

  final Dio dio = Dio();

  Future<(String?, String?)> login({
    required String username,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        'https://flutter-api.janrent.com/api/auth/login',
        data: <String, dynamic>{'username': username, 'password': password},
      );

      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');

      final Map<String, dynamic> json = Map<String, dynamic>.from(
        response.data as Map,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        json['data'] as Map,
      );

      final String? token = data['token']?.toString();

      if (token == null || token.isEmpty) {
        return (null, 'Token not found');
      }

      print('TOKEN: $token');

      return (token, null);
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('RESPONSE: ${e.response?.data}');
      print('MESSAGE: ${e.message}');

      return (
      null,
      e.response?.data?['message']?.toString() ??
          e.response?.data?['detail']?.toString() ??
          e.message ??
          'Login failed',
      );
    } catch (e) {
      print('ERROR: $e');
      return (null, e.toString());
    }
  }

  /// TODO: confirm the real endpoint path — guessed as sibling of /auth/login.
  /// TODO: confirm the real response shape — this assumes
  /// `{"data": {"user": {...}}}` or `{"data": {...user fields directly...}}`
  /// and tries both. Adjust the parsing below once you've seen a real
  /// response (the print statements will show you the raw payload).
  Future<(UserModel?, String?)> register({
    required String email,
    required String password,
    String? referralCode,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        'https://flutter-api.janrent.com/api/auth/register',
        data: <String, dynamic>{
          'username': email,
          'email': email,
          'password': password,
          if (referralCode != null && referralCode.isNotEmpty)
            'referral_code': referralCode,
        },
      );

      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');

      final Map<String, dynamic> json = Map<String, dynamic>.from(
        response.data as Map,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        json['data'] as Map,
      );

      // Some APIs nest the created user under "user"; others return the
      // user fields directly inside "data". Try the nested shape first.
      final Map<String, dynamic> userJson = data['user'] is Map
          ? Map<String, dynamic>.from(data['user'] as Map)
          : data;

      if (userJson['id'] == null && userJson['email'] == null) {
        return (null, 'Unexpected response from server');
      }

      final UserModel user = UserModel.fromJson(userJson);
      return (user, null);
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('RESPONSE: ${e.response?.data}');
      print('MESSAGE: ${e.message}');

      return (
      null,
      e.response?.data?['message']?.toString() ??
          e.response?.data?['detail']?.toString() ??
          e.message ??
          'Registration failed',
      );
    } catch (e) {
      print('ERROR: $e');
      return (null, e.toString());
    }
  }
}