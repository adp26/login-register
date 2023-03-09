import 'package:flutter/material.dart';
import 'package:login_and_register/service/firebase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_and_register/theme.dart';
import 'package:login_and_register/sizeConfig.dart';
import 'package:login_and_register/view/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool visiblePassword = false;
  String uid = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

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

    PreferredSize judul() {
      return PreferredSize(
        child: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          // leadingWidth: 40,
          leading: Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 48,
                height: 48,
                child: ClipOval(
                  child: Material(
                    color: neutralColorWhite, // Warna background tombol
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Register'),
          ),
        ),
        preferredSize: Size.fromHeight(70),
      );
    }

    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register your account to start finding your dream house',
              style: primaryTextStyle.copyWith(
                  fontSize: heading1, fontWeight: semibold),
            ),
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        margin: EdgeInsets.only(
          top: MySize.scaleFactorHeight * 32,
        ),
        child: TextFormField(
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: fullNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Full Name is required';
            }
          },
          style: primaryTextStyle,
          decoration: formDecoration('Full Name', 'Your Full Name'),
        ),
      );
    }

    Widget usernameInput() {
      return Container(
        margin: EdgeInsets.only(
          top: MySize.scaleFactorHeight * 24,
        ),
        child: TextFormField(
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: usernameController,
          style: primaryTextStyle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'UserName is required';
            }
          },
          decoration: formDecoration('UserName', 'Your Username'),
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(
          top: MySize.scaleFactorHeight * 24,
        ),
        child: TextFormField(
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: emailController,
          style: primaryTextStyle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
          },
          decoration: formDecoration('Email', 'Your Email Address'),
        ),
      );
    }

    Widget phoneNumberInput() {
      return Container(
        margin: EdgeInsets.only(
          top: MySize.scaleFactorHeight * 24,
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone Number is required';
            }
          },
          controller: phoneNumberController,
          style: primaryTextStyle,
          decoration: formDecoration('Phone Number', 'Your Phone Number'),
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(
          top: MySize.scaleFactorHeight * 24,
        ),
        child: TextFormField(
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: passwordController,
          style: primaryTextStyle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            } else if (value.length < 6) {
              return 'Enter min. 6 characters';
            }
          },
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

    Widget signUpButtion() {
      return Container(
        height: MySize.getScaledSizeHeight(55),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 30),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              showDialog(
                  context: context,
                  builder: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                  barrierDismissible: false);

              firebaseService service = firebaseService();
              dynamic register = await service.register(
                  email: emailController,
                  password: passwordController,
                  phoneNumber: phoneNumberController,
                  username: usernameController,
                  fullName: fullNameController);
              if (register.runtimeType == bool) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration is Success')));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInPage()));
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(register)));
              }
            }
          },
          child: Text(
            'Submit',
            style:
                navigationTextStyle1.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Text(
              'Already have an account?',
              style: secondaryTextStyle.copyWith(fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Sign In',
                style: navigationTextStyle2.copyWith(
                    fontSize: 12, fontWeight: medium),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: judul(),
        backgroundColor: neutralColorWhite,
        // resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: ListView(
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  nameInput(),
                  usernameInput(),
                  emailInput(),
                  phoneNumberInput(),
                  passwordInput(),
                  SizedBox(
                    height: MySize.getScaledSizeHeight(40),
                  ),
                  signUpButtion(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
