import 'package:flutter/material.dart';
import 'package:login_and_register/service/firebase.dart';
import 'package:login_and_register/service/shared_preferences.dart';
import 'package:login_and_register/theme.dart';
import 'package:login_and_register/sizeConfig.dart';
import 'package:login_and_register/view/onboard_page.dart';
import 'package:login_and_register/view/sign_in_page.dart';

class SuccessPage extends StatefulWidget {
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  List data = [];
  firebaseService firebase = firebaseService();
  @override
  void initState() {
    // TODO: implement initState

    dataValue();
    super.initState();
  }

  dataValue() async {
    // firebaseService firebase = firebaseService();
    // Map data = await firebase.getData(widget.arguments);

    Preferences pref = Preferences();
    data = List.from(await pref.getLoginCredential());
    print(await pref.getLoginCredential());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    Widget buttonLogout() {
      return GestureDetector(
        onTap: () {
          Preferences pref = Preferences();
          pref.deleteCredential();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OnboardPage()),
            (Route<dynamic> route) => false,
          );
        },
        child: Container(
          width: MySize.getScaledSizeWidth(126),
          height: MySize.getScaledSizeHeight(50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: neutralColorWhite),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logout.png',
                width: 20,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Logout',
                style: primaryTextStyle.copyWith(
                    fontSize: heading3, fontWeight: semibold),
              )
            ],
          ),
        ),
      );
    }

    Widget iconSuccess() {
      return Center(
        child: Container(
          child: Column(
            children: [
              Image.asset(
                'assets/check_circle_outline.png',
                height: 124,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Login Access',
                style: navigationTextStyle1.copyWith(
                    fontSize: heading1, fontWeight: semibold),
              ),
            ],
          ),
        ),
      );
    }

    Widget item(String label, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: secondaryTextStyle.copyWith(
                fontSize: heading3, fontWeight: regular),
          ),
          SizedBox(
            height: MySize.getScaledSizeHeight(2),
          ),
          Text(
            value,
            style: primaryTextStyle.copyWith(
                fontSize: heading2, fontWeight: regular),
          ),
          SizedBox(
            height: MySize.getScaledSizeHeight(16),
          ),
        ],
      );
    }

    Widget content() {
      return Center(
        child: Container(
          width: 327,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: neutralColorWhite),
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item("Full Name", data[1] ?? ""),
              item('Email', data[2] ?? ""),
              item('Phone Number', data[3] ?? ""),
            ],
          ),
        ),
      );
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: data.isNotEmpty
                ? Stack(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        iconSuccess(),
                        SizedBox(
                          height: defaultMargin,
                        ),
                        content(),
                      ],
                    ),
                    Positioned(
                      child: buttonLogout(),
                      left: MySize.getScaledSizeWidth(245),
                      top: MySize.getScaledSizeHeight(25),
                    ),
                  ])
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Loading. . .",
                            style: navigationTextStyle1.copyWith(
                                fontSize: heading2, fontWeight: semibold))
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
