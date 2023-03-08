import 'package:flutter/material.dart';
import 'package:login_and_register/service/firebase.dart';
import 'package:login_and_register/service/shared_preferences.dart';
import 'package:login_and_register/sizeConfig.dart';
import 'package:login_and_register/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_and_register/view/sign_up_page.dart';
import 'package:login_and_register/view/sucess_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool visiblePassword = false;
  String uid = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
        barrierDismissible: false);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              // email: 'achmaddp26@gmail.com',
              // password: "12345678asd");
              password: passwordController.text.trim())
          // .timeout(Duration(seconds: 5), onTimeout: timeOut())
          .then((value) async {
        print('keisni');
        uid = (value.user?.uid).toString();
        // print(value.user?.uid);
        firebaseService firebase = firebaseService();
        Preferences pref = Preferences();
        var data = await firebase.getData(uid);
        print(data);
        if (data != null) {
          pref.SetLoginCredential(
              uid: uid,
              phoneNumber: data['phoneNumber'],
              email: data['email'],
              fullName: data['name']);
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SuccessPage()),
            (Route<dynamic> route) => false,
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      print("error");
      print(e);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    Widget backButton() {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32), color: Colors.white),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }

    Widget header() {
      return Stack(children: [
        Container(
          width: double.infinity,
          child: Image.asset(
            'assets/login-cover.png',
            // width: MySize.getScaledSizeWidth(375),
            height: MySize.getScaledSizeHeight(270),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
            left: defaultMargin, top: defaultMargin, child: backButton()),
      ]);
    }

    Widget instruksi() {
      return Container(
        margin:
            EdgeInsets.only(top: 30, left: defaultMargin, right: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To get started, first enter your email and password',
              style: primaryTextStyle.copyWith(
                  fontSize: heading1, fontWeight: semibold),
            ),
          ],
        ),
      );
    }

    InputDecoration formDecoration(String label, String hintText) {
      return InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          label: Text(label),
          hintText: hintText,
          hintStyle: secondaryTextStyle.copyWith(
              fontSize: heading3, fontWeight: regular));
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(
            top: MySize.scaleFactorHeight * 70,
            left: MySize.getScaledSizeWidth(defaultMargin),
            right: MySize.getScaledSizeWidth(defaultMargin)),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            } else {
              print(value);
            }
          },
          controller: emailController,
          style: primaryTextStyle,
          decoration: formDecoration('Email', 'Your Email Address'),
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(
            top: 20,
            left: MySize.getScaledSizeWidth(defaultMargin),
            right: MySize.getScaledSizeWidth(defaultMargin)),
        child: TextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            } else if (value.length < 6) {
              return 'Enter min. 6 characters';
            }
          },
          style: primaryTextStyle,
          obscureText: !visiblePassword,
          decoration: formDecoration('Password', 'Your Password').copyWith(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (visiblePassword) {
                        visiblePassword = false;
                      } else {
                        visiblePassword = true;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: visiblePassword ? Colors.blue : Colors.grey,
                  ))),
        ),
      );
    }

    Widget signInButtion() {
      return Container(
        height: MySize.getScaledSizeHeight(55),
        width: double.infinity,
        margin:
            EdgeInsets.only(top: 30, left: defaultMargin, right: defaultMargin),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              signIn();
            }
            // signIn();
            // Navigator.pushNamed(context, '/success');
          },
          child: Text(
            'Login',
            style:
                navigationTextStyle1.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(
            bottom: 30, left: defaultMargin, right: defaultMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Forgot Password',
              style: navigationTextStyle2.copyWith(
                  fontSize: heading3, fontWeight: semibold),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, '/sign-up');
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Text(
                'Don\'t have an account?',
                style: navigationTextStyle2.copyWith(
                    fontSize: heading3, fontWeight: semibold),
              ),
            )
          ],
          // mainAxisAlignment: MainAxisAlignment.center,
        ),
      );
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        // appBar: backButton(),
        backgroundColor: neutralColorWhite,
        // untuk menghilangkan police line ketika keyboard muncul
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Form(
              key: _formKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  instruksi(),
                  emailInput(),
                  passwordInput(),
                  SizedBox(
                    height: MySize.getScaledSizeHeight(30),
                  ),
                  signInButtion(),
                  SizedBox(
                    height: MySize.getScaledSizeHeight(20),
                  ),
                  footer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
