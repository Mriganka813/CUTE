// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, must_be_immutable
import 'dart:async';

import 'package:cute/constant/custom_snackbar.dart';
import 'package:cute/pages/profile/signup_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:cute/constant/constant.dart';
import 'package:cute/pages/bottom_bar.dart';
import 'package:cute/services/auth.dart';
import 'package:cute/services/global.dart';
import 'package:cute/services/locator.dart';

class OTPScreen extends StatefulWidget {
  String phonenumber;
  OTPScreen({
    Key? key,
    required this.phonenumber,
  }) : super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Color continueButtonColor = Colors.grey;
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();

  // My_Changes

  final _authInstace = FirebaseAuth.instance;
  String _verificationId = "";
  String code = "";
  String smsotp = "";
  String name = "";
  String address = "";
  bool isverified = false;
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    getotp(widget.phonenumber);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(fixPadding * 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verify mobile number',
                        style: blackLargeTextStyle,
                      ),
                      heightSpace,
                      heightSpace,
                      Text(
                        'Enter the OTP sent to your mobile number',
                        style: greySmallTextStyle,
                      ),
                      SizedBox(height: 50.0),
                      // OTP Box Start
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          code == ""
                              ? otpfild("")
                              : otpfild(code.characters.elementAt(0)),
                          code == ""
                              ? otpfild("")
                              : otpfild(code.characters.elementAt(1)),
                          code == ""
                              ? otpfild("")
                              : otpfild(code.characters.elementAt(2)),
                          code == ""
                              ? otpfild("")
                              : otpfild(code.characters.elementAt(3)),
                          code == ""
                              ? otpfild("")
                              : otpfild(code.characters.elementAt(4)),
                          code == ""
                              ? otpfild("")
                              : otpfild(code.characters.elementAt(5)),
                        ],
                      ),
                      // OTP Box End
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(fixPadding * 2.0),
            child: InkWell(
              onTap: () async {
                if (smsotp == "" && code == "") {
                  locator<GlobalServices>()
                      .errorSnackBar("Verification Failed");
                  SnackBarWidget.showErrorBar(context, "Verification Failed");
                  return;
                }
                await verifyOtp();
                isverified
                    ? await auth
                        .signInRequest(int.parse(widget.phonenumber))
                        .then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomBar()),
                            (route) => false);
                      }).catchError((e) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignupProfile(phone: widget.phonenumber),
                          ),
                        );
                      })
                    : Navigator.pop(context);
              },
              child: AnimatedContainer(
                width: width - fixPadding * 2.0,
                padding: EdgeInsets.all(fixPadding * 1.0),
                duration: Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: continueButtonColor,
                ),
                child: Text(
                  'Continue',
                  style: whiteBottonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  getotp(String phone) async {
    // SnackBarWidget.showInfoBar(context, "Sending OTP...");
    await _authInstace.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        setState(() {
          code = credential.smsCode!;
          continueButtonColor = primaryColor;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        locator<GlobalServices>().errorSnackBar("Verification Failed");
        SnackBarWidget.showErrorBar(context, "Verification Failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        locator<GlobalServices>().successSnackBar("Code sent");
        SnackBarWidget.showInfoBar(context, "Code sent");
        setState(() {
          _verificationId = verificationId;
          continueButtonColor = primaryColor;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  ///
  verifyOtp() async {
    locator<GlobalServices>().infoSnackBar("Verifying...");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code != "" ? code : smsotp);

    try {
      await _authInstace.signInWithCredential(credential).then((value) {
        locator<GlobalServices>().successSnackBar("Verified ✓");
        SnackBarWidget.showSuccessBar(context, "Verified ✓");
        setState(() {
          isverified = true;
        });
      });
    } catch (e) {
      locator<GlobalServices>().errorSnackBar("Verificastion falied");
      SnackBarWidget.showErrorBar(context, "Verification Failed");
      setState(() {
        code = "";
        smsotp = "";
        // isverified = true;
      });
    }
  }

  Widget otpfild(digit) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width / 7;
    // print(digit);
    return Container(
      width: width / 1.2,
      height: height / 13,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 0.2, color: primaryColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 1.5,
            spreadRadius: 1.5,
            color: Colors.grey.shade300,
          ),
        ],
      ),
      child: TextFormField(
        key: Key(digit),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
        initialValue: digit,
        onChanged: (value) {
          if (value.length == 1) {
            smsotp = smsotp + value;
            FocusScope.of(context).nextFocus();
          }
        },
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: height / 30, fontFamily: 'Gilroy Bold'),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  loadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 150.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitRing(
                  color: primaryColor,
                  lineWidth: 1.5,
                  size: 35.0,
                ),
                heightSpace,
                heightSpace,
                Text('Please Wait..', style: greySmallTextStyle),
              ],
            ),
          ),
        );
      },
    );
    Timer(
        Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomBar()),
            ));
  }
}
