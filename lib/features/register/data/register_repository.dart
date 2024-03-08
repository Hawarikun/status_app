import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:status_app/core/apis/auth.dart';
import 'package:status_app/core/helper/api.dart';

class RegisterRepository {
  RegisterRepository(this.api);
  final AuthApi api;

  register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await ApiHelper().postData(
      uri: api.register(),
      builder: (data) {},
      header: ApiHelper.header(),
      jsonBody: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
  }
}

final registerRepoProv = Provider(
  (ref) {
    final api = AuthApi();
    return RegisterRepository(api);
  },
);
