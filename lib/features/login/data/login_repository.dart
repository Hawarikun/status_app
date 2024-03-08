import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_app/core/apis/auth.dart';
import 'package:status_app/core/datas/shared_preferences.dart';
import 'package:status_app/core/helper/api.dart';

class LoginRepository {
  LoginRepository(this.api);
  final AuthApi api;

  login({required String email, required String password}) async {
    return await ApiHelper().postData(
      uri: api.login(),
      builder: (data) async {
        LocalPrefsRepository().saveToken(data["loginResult"]["token"]);
      },
      header: ApiHelper.header(),
      jsonBody: {
        "email": email,
        "password": password,
      },
    );
  }
}

final loginRepoProv = Provider((ref) {
  final api = AuthApi();
  return LoginRepository(api);
});
