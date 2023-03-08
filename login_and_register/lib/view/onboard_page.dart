import 'package:flutter/material.dart';
import 'package:login_and_register/theme.dart';
import 'package:login_and_register/view/sign_in_page.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:login_and_register/sizeConfig.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        width: double.infinity,
        child: Image.asset(
          'assets/onboarding-cover.png',
          width: MySize.getScaledSizeWidth(375),
          height: MySize.getScaledSizeHeight(322),
          fit: BoxFit.fill,
        ),
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.fromLTRB(
            defaultMargin, defaultMargin, defaultMargin, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find your',
              style: primaryTextStyle.copyWith(
                  fontWeight: extrabold, fontSize: displaySize),
            ),
            Row(
              children: [
                GradientText(
                  'dream',
                  style:
                      TextStyle(fontSize: displaySize, fontWeight: extrabold),
                  gradientType: GradientType.linear,
                  gradientDirection: GradientDirection.ltr,
                  radius: .9,
                  colors: [
                    secondaryColorRed,
                    secondaryColorGradient,
                  ],
                ),
                Text(
                  ' house',
                  style: primaryTextStyle.copyWith(
                      fontWeight: extrabold, fontSize: displaySize),
                ),
              ],
            ),
            SizedBox(
              height: MySize.getScaledSizeHeight(16),
            ),
            Text(
              'Aven Residence provides several houses with strategic locations and affordable prices.',
              style: secondaryTextStyle.copyWith(
                  fontSize: heading1, fontWeight: regular),
            )
          ],
        ),
      );
    }

    Widget getStartedButtion() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
          onPressed: () {
            // Navigator.pushNamed(context, '/sign-in');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignInPage()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: navigationTextStyle1.copyWith(
                    fontSize: heading3, fontWeight: semibold),
              ),
              SizedBox(
                width: MySize.getScaledSizeHeight(9.8),
              ),
              Image.asset(
                'assets/east.png',
                width: 20,
              )
            ],
          ),
        ),
      );
    }

    MySize().init(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                header(),
                SizedBox(
                  height: MySize.getScaledSizeHeight(defaultMargin),
                ),
                content(),
                Spacer(),
                getStartedButtion(),
                SizedBox(
                  height: MySize.getScaledSizeHeight(36),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
