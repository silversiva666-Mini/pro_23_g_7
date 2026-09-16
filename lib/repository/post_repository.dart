import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:pro_23/model/post_daa_model.dart';

import '../service/storage_service.dart';


class PostRepository {
  PostRepository();

  final Dio dio = Dio();

  // ============================================================
  // GET POSTS
  // ============================================================

  Future<(PostDataModel?, String?)> getPageTest({
    int page = 0,
    int size = 10,
    String? title,
    bool? published,
  }) async {
    try {
      final Response<dynamic> response = await dio.get(
        'https://flutter-api.janrent.com/api/posts',
        queryParameters: <String, dynamic>{
          'page': page,
          'size': size,
          'sortBy': 'createdAt',
          'direction': 'desc',

          if (title != null && title.isNotEmpty)
            'title': title,

          if (published != null)
            'published': published,
        },
      );

      print('GET POSTS STATUS: ${response.statusCode}');
      print('GET POSTS DATA: ${response.data}');

      final Map<String, dynamic> json =
      response.data as Map<String, dynamic>;

      return (PostDataModel.fromJson(json), null);
    } on DioException catch (e) {
      print('GET POSTS ERROR STATUS: ${e.response?.statusCode}');
      print('GET POSTS ERROR DATA: ${e.response?.data}');

      return (
      null,
      _getDioError(e, 'Get posts failed'),
      );
    } catch (e) {
      return (null, e.toString());
    }
  }

  // ============================================================
  // CREATE POST
  // ============================================================

  Future<(Data?, String?)> createPost({
    required String title,
    required String content,
    required bool published,
  }) async {
    try {
      final String? token = await _getToken();

      // ✅ Only send POST information here.
      // ✅ Do NOT send Base64 image here.
      final Map<String, dynamic> requestData = <String, dynamic>{
        'title': title,
        'content': content,
        'published': published,
      };

      final Response<dynamic> response = await dio.post(
        'https://flutter-api.janrent.com/api/posts',
        data: requestData,
        options: Options(
          headers: <String, dynamic>{
            if (token != null)
              'Authorization': 'Bearer $token',

            'Content-Type': 'application/json',
          },
        ),
      );

      print('CREATE POST STATUS: ${response.statusCode}');
      print('CREATE POST DATA: ${response.data}');

      final Map<String, dynamic> json =
      response.data as Map<String, dynamic>;

      final Data? createdPost =
      json['data'] != null
          ? Data.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null;

      return (createdPost, null);
    } on DioException catch (e) {
      print('CREATE POST ERROR STATUS: ${e.response?.statusCode}');
      print('CREATE POST ERROR DATA: ${e.response?.data}');

      return (
      null,
      _getDioError(e, 'Create post failed'),
      );
    } catch (e) {
      return (null, e.toString());
    }
  }

  // ============================================================
  // UPDATE POST
  // ============================================================

  Future<(Data?, String?)> updatePost({
    required String id,
    String? title,
    String? content,
    bool? published,
  }) async {
    try {
      final String? token = await _getToken();

      final Map<String, dynamic> requestData = <String, dynamic>{
        if (title != null)
          'title': title,

        if (content != null)
          'content': content,

        if (published != null)
          'published': published,
      };

      final Response<dynamic> response = await dio.put(
        'https://flutter-api.janrent.com/api/posts/$id',
        data: requestData,
        options: Options(
          headers: <String, dynamic>{
            if (token != null)
              'Authorization': 'Bearer $token',

            'Content-Type': 'application/json',
          },
        ),
      );

      print('UPDATE POST STATUS: ${response.statusCode}');
      print('UPDATE POST DATA: ${response.data}');

      final Map<String, dynamic> json =
      response.data as Map<String, dynamic>;

      final Data? updatedPost =
      json['data'] != null
          ? Data.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null;

      return (updatedPost, null);
    } on DioException catch (e) {
      print('UPDATE POST ERROR STATUS: ${e.response?.statusCode}');
      print('UPDATE POST ERROR DATA: ${e.response?.data}');

      return (
      null,
      _getDioError(e, 'Update post failed'),
      );
    } catch (e) {
      return (null, e.toString());
    }
  }

  // ============================================================
  // UPLOAD IMAGE
  // ============================================================
  Future<(Data?, String?)> uploadPostImage({
    required String postId,
    required File image,
  }) async {
    try {
      final StorageService storageService = StorageService();

      final String? token = await storageService.getString('token');

      final String fileName =
          image.path.split(Platform.pathSeparator).last;

      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final Response<dynamic> response = await dio.post(
        'https://flutter-api.janrent.com/api/posts/$postId/image',
        data: formData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
          contentType: 'multipart/form-data',
        ),
      );

      print('UPLOAD IMAGE STATUS: ${response.statusCode}');
      print('UPLOAD IMAGE DATA: ${response.data}');

      final Map<String, dynamic> json =
      Map<String, dynamic>.from(response.data);

      if (json['data'] != null) {
        return (
        Data.fromJson(
          Map<String, dynamic>.from(json['data']),
        ),
        null,
        );
      }

      return (null, 'No post data returned');
    } on DioException catch (e) {
      print('UPLOAD IMAGE FAILED');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');

      return (
      null,
      e.response?.data?.toString() ?? e.message ?? 'Image upload failed',
      );
    } catch (e) {
      return (null, e.toString());
    }
  }

  // ============================================================
  // DELETE POST
  // ============================================================

  Future<(bool, String?)> deletePost(String id) async {
    try {
      final String? token = await _getToken();

      final Response<dynamic> response = await dio.delete(
        'https://flutter-api.janrent.com/api/posts/$id',
        options: Options(
          headers: <String, dynamic>{
            if (token != null)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      print('DELETE POST STATUS: ${response.statusCode}');
      print('DELETE POST DATA: ${response.data}');

      return (true, null);
    } on DioException catch (e) {
      print('DELETE POST ERROR STATUS: ${e.response?.statusCode}');
      print('DELETE POST ERROR DATA: ${e.response?.data}');

      return (
      false,
      _getDioError(e, 'Delete post failed'),
      );
    } catch (e) {
      return (false, e.toString());
    }
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  Future<String?> _getToken() async {
    final StorageService storageService =
    Get.isRegistered<StorageService>()
        ? Get.find<StorageService>()
        : Get.put(
      StorageService(),
      permanent: true,
    );

    return await storageService.getString('token');
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getDioError(
      DioException e,
      String defaultMessage,
      ) {
    final dynamic data = e.response?.data;

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        return data['message'].toString();
      }

      if (data['detail'] != null) {
        return data['detail'].toString();
      }

      if (data['error'] != null) {
        return data['error'].toString();
      }
    }

    if (data != null) {
      return data.toString();
    }

    return e.message ?? defaultMessage;
  }
}