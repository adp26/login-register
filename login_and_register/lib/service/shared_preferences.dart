import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Future<void> SetLoginCredential(
      {required String uid,
      required String phoneNumber,
      required String email,
      required String fullName}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // sharedPreferences.setString("uid", uid);
    // sharedPreferences.setString("fullname", fullName);
    // sharedPreferences.setString("email", email);
    sharedPreferences
        .setStringList('data', [uid, fullName, email, phoneNumber]);
  }

  Future<List> getLoginCredential() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List? strReturn = sharedPreferences.getStringList("data") ?? [];

    return strReturn;
  }
}
