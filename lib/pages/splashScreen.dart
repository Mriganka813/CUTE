import 'dart:async';

import 'package:cute/constant/constant.dart';
import 'package:cute/pages/bottom_bar.dart';
import 'package:cute/pages/login_signup/login.dart';
import 'package:cute/pages/login_signup/walkthrough.dart';
import 'package:cute/services/api_v1.dart';
import 'package:cute/services/auth.dart';
import 'package:cute/services/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService auth = AuthService();
  @override
  void initState() {
    super.initState();
    authStatus();
  }

  Future<void> authStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String access_token = prefs.getString('access_token') ?? "";
    final String refresh_token = prefs.getString('refresh_token') ?? "";

    final isAuthenticated = access_token.isNotEmpty;

    print(access_token);
    print(refresh_token);

    if (isAuthenticated) {
      try {
        await auth.getUser();
      } catch (e) {
        print("error in getting user");
        await auth.getUser();
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => BottomBar()),
          (route) => false);
      prefs.reload();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(builder: (BuildContext context) => Login()),
          (route) => false);
    }

    // Future.delayed(
    //   const Duration(milliseconds: 6000),
    //   () => Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute<void>(
    //           builder: (BuildContext context) =>
    //               isAuthenticated ? BottomBar() : Login())),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueColor,
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'CourierPro',
                style: splashBigTextStyle,
              ),
              heightSpace,
              Text(
                'on-demand delivery available 24x7',
                style: whiteNormalTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
