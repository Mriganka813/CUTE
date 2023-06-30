import 'dart:io';

import 'package:cute/model/Input/signupinput.dart';
import 'package:cute/model/Input/user.dart';
import 'package:cute/services/api_v1.dart';
import 'package:cute/services/const.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shopos/src/models/input/sign_up_input.dart';
// import 'package:shopos/src/models/user.dart';

class AuthService {
  const AuthService();

  ///
  /// Send verification code
  Future<bool> sendVerificationCode(String phoneNumber) async {
    final response = await ApiV1Service.postRequest('/api/v1/sendOtp');
    if ((response.statusCode ?? 400) < 300) {
      return true;
    }
    return false;
  }

  /// Send login request
  Future<SignUpInput?> signUpRequest(SignUpInput input) async {
    print(input.toMap());
    final response = await ApiV1Service.postRequest(
      '/auth/signup',
      data: input.toMap(),
    );
    if ((response.statusCode ?? 400) > 300) {
      return null;
    }
    // // print(response.statusCode);
    print(response.toString());
    String user_id = response.data['user_id'];
    final reponse2 = await ApiV1Service.postRequest(
      '/auth/signup/verify',
      data: {"user_id": user_id},
    );
    await signInRequest(input.phoneNumber!);
    // await saveCookie(response);
    // return SignUpInput.fromMap(response.data['user']);
  }

  /// Save cookies after sign in/up
  Future<void> saveCookie(Response response) async {
    List<Cookie> cookies = [Cookie("token", response.data['token'])];
    final cj = await ApiV1Service.getCookieJar();
    await cj.saveFromResponse(Uri.parse(Const.apiUrl), cookies);
  }

  ///
  Future<void> signOut() async {
    await clearCookies();
    await SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
    await fb.FirebaseAuth.instance.signOut();
  }

  /// Clear cookies before log out
  Future<void> clearCookies() async {
    final cj = await ApiV1Service.getCookieJar();
    await cj.deleteAll();
  }

  /// Send sign in request
  ///
  Future<User?> signInRequest(int phoneNum) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await ApiV1Service.postRequest(
      '/auth/login',
      data: {
        'phoneNum': phoneNum,
        'password': "qwertyuiop",
      },
    );
    if ((response.statusCode ?? 400) > 300) {
      return null;
    }
    var token = response.data['tokens'];
    final String access_token = token['access'];
    final String refresh_token = token['refresh'];
    await prefs.setString('access_token', access_token);
    await prefs.setString('refresh_token', refresh_token);
    print("toekn saved succesfully");
    return null;
    // return User.fromMap(response.data['user']);
  }

  /// get token from server
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String access_token = prefs.getString('access_token') ?? "";

    User usr = User();
    try {
      await ApiV1Service.getRequest('/auth', token: access_token).then((value) {
        print(value.data['user']);
        usr = User.fromMap(value.data['user']);
        return User.fromMap(value.data['user']);
      });
    } catch (e) {
      print("token expired");
      await getNewToken();
    }

    // .catchError((e) async {
    //   print("token expired");
    //   getNewToken();
    // });
    return usr;
  }

  /// get new token from server
  getNewToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String refresh_token = prefs.getString('refresh_token') ?? "";
    final response =
        await ApiV1Service.getRequest('/auth/newtoken', token: refresh_token);
    if ((response.statusCode ?? 400) > 300) {
      return null;
    }
    final String access_token = response.data['token'];
    await prefs.setString('access_token', access_token);
    await prefs.reload();
    getUser();
  }

  ///password change request
  ///
  Future<bool> PasswordChangeRequest(
      String oldPassword, String newPassword, String confirmPassword) async {
    final response = await ApiV1Service.putRequest(
      '/password/update',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    if ((response.statusCode ?? 400) > 300) {
      return false;
    }
    return true;
  }

  ///password change request
  ///
  Future<bool> ForgotPasswordChangeRequest(
      String newPassword, String confirmPassword, String phoneNumber) async {
    // print(newPassword + " " + confirmPassword + " " + phoneNumber);
    final response = await ApiV1Service.putRequest(
      '/password/reset',
      data: {
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'phoneNumber': phoneNumber,
      },
    );
    if ((response.statusCode ?? 400) > 300) {
      return false;
    }
    return true;
  }
}
