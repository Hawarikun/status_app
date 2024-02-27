import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localPrefsRProvider = Provider((ref) => LocalPrefsRepository());

abstract class PrefsRepository {
  Future saveToken(String token);
  Future deleteToken();
  Future getToken();
}

class LocalPrefsRepository implements PrefsRepository {
  ///send your <<TOKEN>> to this method
  @override
  Future saveToken(String token) async {
    final prefs = await _open();
    return await prefs.setString("token", token);
  }

  ///delete your <<TOKEN>>
  @override
  Future deleteToken() async {
    final prefs = await _open();
    return await prefs.remove("token");
  }

  @override
  Future<String?> getToken() async {
    final prefs = await _open();
    return prefs.getString("token");
  }

  Future<SharedPreferences> _open() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}
