import 'package:dio/dio.dart';

import '../model/user_model.dart';

class UserRepository {
  UserRepository();

  final Dio dio = Dio();

  /// TODO: confirm real pagination query param names (page/limit here are a
  /// guess — some APIs use page/per_page, or offset/limit) and confirm the
  /// response includes a total count (guessed at json['meta']['total'] or
  /// json['total']). Check the printed DATA below against your real response.
  Future<(List<UserModel>?, int?, String?)> getUsers({
    required int page,
    int limit = 20,
  }) async {
    try {
      final Response<dynamic> response = await dio.get(
        'https://flutter-api.janrent.com/api/users',
        queryParameters: <String, dynamic>{'page': page, 'limit': limit},
      );

      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');

      final Map<String, dynamic> json = Map<String, dynamic>.from(
        response.data as Map,
      );

      final List<dynamic> data = json['data'] is List
          ? json['data'] as List
          : <dynamic>[];

      final List<UserModel> users = data
          .map((dynamic e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      final int? total = json['total'] is int
          ? json['total'] as int
          : (json['meta'] is Map ? (json['meta']['total'] as int?) : null);

      return (users, total, null);
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('RESPONSE: ${e.response?.data}');
      print('MESSAGE: ${e.message}');

      return (
      null,
      null,
      e.response?.data?['message']?.toString() ??
          e.response?.data?['detail']?.toString() ??
          e.message ??
          'Failed to load users',
      );
    } catch (e) {
      print('ERROR: $e');
      return (null, null, e.toString());
    }
  }
}