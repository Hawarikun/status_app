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
        case HttpStatus.unauthorized:
          LocalPrefsRepository().deleteToken();
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
          AppRoutes().clearAndNavigate(AppRoutes.auth);
          throw Exception("token no longer valid");
        case HttpStatus.unprocessableEntity:
          final data = jsonDecode(response.body);
          throw Exception(data);
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
      path: "${ApiConfig.api}$endpoint",
      queryParameters: params,
    );

    return uri;
  }

  static Map<String, String> header() {
    return {
      'Content-Type': 'application/json',
    };
  }

  static Map<String, String> headerStory(String token) {
    return {
      "Authorization": "Bearer $token",
    };
  }
}
