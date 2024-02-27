import '../helper/api.dart';

class AuthApi {
  Uri login() {
    return ApiHelper.buildUri(endpoint: "login");
  }

  Uri register() {
    return ApiHelper.buildUri(endpoint: "register");
  }
  }

  Uri logout() {
    return ApiHelper.buildUri(endpoint: "logout");
  }