import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_and_register/service/shared_preferences.dart';
import 'package:login_and_register/sizeConfig.dart';
import 'package:login_and_register/theme.dart';
import 'package:login_and_register/view/onboard_page.dart';
import 'package:login_and_register/view/sign_in_page.dart';
import 'package:login_and_register/view/sign_up_page.dart';
import 'package:login_and_register/view/sucess_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});
  Preferences pref = Preferences();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<List?>(
        future: pref.getLoginCredential(),
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
          bool bolLoginValid = false;
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              bolLoginValid = true;

              if (bolLoginValid) {
                return SuccessPage();
              }
            } else {
              return OnboardPage();
            }
          }
          return Scaffold(
            backgroundColor: primaryColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
