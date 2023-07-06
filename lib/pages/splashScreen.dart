// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:cute/constant/constant.dart';
import 'package:cute/pages/bottom_bar.dart';
import 'package:cute/pages/login_signup/login.dart';
import 'package:cute/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
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
    _checkUpdate();
  }

  final newVersionPlus = NewVersionPlus();
  Future<void> _checkUpdate() async {
    final status = await newVersionPlus.getVersionStatus();
    if (status!.canUpdate) {
      newVersionPlus.showUpdateDialog(
          context: context, versionStatus: status, allowDismissal: false);
    } else {
      authStatus();
    }
  }

  Future<void> authStatus() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    final prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? "";
    // final String refreshToken = prefs.getString('refresh_token') ?? "";

    final isAuthenticated = accessToken.isNotEmpty;

    // print(access_token);
    // print(refresh_token);

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
      backgroundColor: Color.fromRGBO(0, 191, 99, 1),
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Center(child: Image.asset('assets/iconc.png')),
        ),
      ),
    );
  }
}
