import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:status_app/core/configs/api.dart';
import 'package:status_app/core/configs/routes.dart';
import 'package:status_app/core/datas/shared_preferences.dart';

class ApiHelper {
  final http.Client client = http.Client();

  Future<T> getData<T>({
    required Uri uri,
    required T Function(dynamic data) builder,
    Map<String, String>? header,
  }) async {
    try {
      final response = await client.get(
        uri,
        headers: header,
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final data = jsonDecode(response.body);
          return builder(data);
        case HttpStatus.notFound:
          throw Exception("endpoint not found");
        case HttpStatus.unauthorized:
          LocalPrefsRepository().deleteToken();
          // LocalPrefsRepository().deleteCitizen();
          // LocalPrefsRepository().deleteUser();
          AppRoutes().clearAndNavigate(AppRoutes.auth);
          throw Exception("token no longer valid");
        default:
          final data = jsonDecode(response.body);
          throw Exception(data.toString());
      }
    } on SocketException catch (_) {
      throw Exception("No Internet Connection");
    }
  }

  Future<T> postData<T>({
    required Uri uri,
    required T Function(dynamic data) builder,
    Map<String, String>? header,
    Map<String, dynamic>? jsonBody,
  }) async {
    try {
      final response = await client.post(
        uri,
        headers: header,
        body: jsonEncode(jsonBody),
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final data = jsonDecode(response.body);
          return builder(data);
        case HttpStatus.created:
          final data = jsonDecode(response.body);
          return builder(data);
        case HttpStatus.unauthorized:
          LocalPrefsRepository().deleteToken();
          // LocalPrefsRepository().deleteCitizen();
          // LocalPrefsRepository().deleteUser();
          AppRoutes().clearAndNavigate(AppRoutes.auth);
          throw Exception("token no longer valid");
        case HttpStatus.unprocessableEntity:
          final data = jsonDecode(response.body);
          throw Exception(data["message"]);
        case HttpStatus.notFound:
          throw Exception("endpoint not found");
        default:
          final data = jsonDecode(response.body);
          throw Exception(data.toString());
      }
    } on SocketException catch (_) {
      throw Exception("No Internet Connection");
    }
  }

  Future<T> patchData<T>({
    required Uri uri,
    required T Function(dynamic data) builder,
    Map<String, String>? header,
    Map<String, dynamic>? jsonBody,
  }) async {
    try {
      final response = await client.patch(
        uri,
        headers: header,
        body: jsonEncode(jsonBody),
      );
      switch (response.statusCode) {
        case HttpStatus.ok:
          final data = jsonDecode(response.body);
          return builder(data);
        case HttpStatus.unauthorized:
          LocalPrefsRepository().deleteToken();
          // LocalPrefsRepository().deleteCitizen();
          // LocalPrefsRepository().deleteUser();
          AppRoutes().clearAndNavigate(AppRoutes.auth);
          throw Exception("token no longer valid");
        case HttpStatus.unprocessableEntity:
          final data = jsonDecode(response.body);
          throw Exception(data["message"]);
        case HttpStatus.notFound:
          throw Exception("endpoint not found");
        default:
          final data = jsonDecode(response.body);
          throw Exception(data.toString());
      }
    } on SocketException catch (_) {
      throw Exception("No Internet Connection");
    }
  }

  Future<T> postImageData<T>({
    required Uri uri,
    required Map<String, File?> files,
    required T Function(dynamic data) builder,
    Map<String, String>? fields,
    Map<String, String>? header,
  }) async {
    try {
      final x = http.MultipartRequest("POST", uri);

      files.forEach((key, value) async {
        if (value != null) {
          final multipartFile = await http.MultipartFile.fromPath(
            key,
            value.path,
          );
          x.files.add(multipartFile);
        }
      });

      if (fields != null) {
        x.fields.addAll(fields);
      }

      if (header != null) {
        x.headers.addAll(header);
      }

      final streamedRespoonse = await x.send();
      final response = await http.Response.fromStream(streamedRespoonse);

      switch (response.statusCode) {
        case HttpStatus.ok:
          final data = jsonDecode(response.body);
          return builder(data);
        case HttpStatus.unauthorized:
          LocalPrefsRepository().deleteToken();
          // LocalPrefsRepository().deleteCitizen();
          // LocalPrefsRepository().deleteUser();
          AppRoutes().clearAndNavigate(AppRoutes.auth);
          throw Exception("token no longer valid");
        case HttpStatus.notFound:
          throw Exception("endpoint not found");
        default:
          final data = jsonDecode(response.body);
          throw Exception(data.toString());
      }
    } on SocketException catch (_) {
      throw Exception("No Internet Connection");
    }
  }

  static Uri buildUri({
    required String endpoint,
    Map<String, String>? params,
  }) {
    var uri = Uri(
      scheme: "https",
      host: ApiConfig.baseUrl,
      // path: "${ApiConfig.api}$endpoint",
      queryParameters: params,
    );
    return uri;
  }

  static Map<String, String> header() {
    return {
      "accept": "application/json",
      "content-type": "application/json",
    };
  }

  static Map<String, String> tokenHeader(String token) {
    return {
      "accept": "application/json",
      "content-type": "application/json",
      "authorization": "Bearer $token",
    };
  }

  static Map<String, String> tokenHeaderMultipart(String token) {
    return {
      "accept": "application/json",
      "authorization": "Bearer $token",
    };
  }
}
