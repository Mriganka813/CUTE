import 'package:cute/constant/constant.dart';
import 'package:cute/pages/courier/send_packages.dart';
import 'package:cute/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loadinglocation = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    loadingDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
    }

    getLoc() async {
      loadingDialog();
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition();
      Navigator.pop(context, true);
      return [position.latitude, position.longitude];
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 1.0,
        title: Text('Welcome', style: appBarTextStyle),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: primaryColor),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: Profile()));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(fixPadding * 2.0),
            child: Image.asset(
              'assets/banner.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          heightSpace,
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         PageTransition(
          //             type: PageTransitionType.scale,
          //             alignment: Alignment.bottomCenter,
          //             child: InviteFriend()));
          //   },
          //   child: Container(
          //     padding: EdgeInsets.all(fixPadding * 2.0),
          //     color: lightPrimaryColor,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Image.asset(
          //               'assets/icons/wallet.png',
          //               width: 35.0,
          //               height: 35.0,
          //               fit: BoxFit.fitHeight,
          //             ),
          //             widthSpace,
          //             Container(
          //               width: width - (fixPadding * 4.0 + 35.0 + 30.0 + 10.0),
          //               child: Text(
          //                   'Invite friends to Courier Pro to earn upto \$20 Courier Pro Cash',
          //                   style: blackSmallTextStyle),
          //             ),
          //           ],
          //         ),
          //         Container(
          //           width: 30.0,
          //           alignment: Alignment.centerRight,
          //           child: Icon(Icons.arrow_forward_ios,
          //               color: greyColor, size: 18.0),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Courier Type Start

          // Send Packages Start
          InkWell(
            onTap: () async {
              await getLoc().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendPackages(
                          kInitialPosition: LatLng(value[0], value[1])))));
            },
            child: Hero(
              tag: 'Send Packages',
              child: Container(
                margin: EdgeInsets.only(
                    top: fixPadding * 2.0,
                    right: fixPadding * 2.0,
                    left: fixPadding * 2.0),
                padding: EdgeInsets.all(fixPadding * 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor,
                  border: Border.all(width: 0.2, color: primaryColor),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 1.5,
                      spreadRadius: 1.5,
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        color: primaryColor.withOpacity(0.2),
                      ),
                      child: Image.asset(
                        'assets/icons/parcel_type.png',
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    widthSpace,
                    Container(
                      width: width - (fixPadding * 8.0 + 70.0 + 10.0 + 0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Send Packages',
                              style: primaryColorHeadingTextStyle),
                          Text('Send packages to anywhere and anytime.',
                              style: greySmallTextStyle)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Send Packages Start

          // Food Deliver Start
          InkWell(
            onTap: () async {
              await getLoc().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendPackages(
                          kInitialPosition: LatLng(value[0], value[1])))));
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => GetFoodDeliver()));
            },
            child: Hero(
              tag: 'Get Food Deliver',
              child: Container(
                margin: EdgeInsets.only(
                    top: fixPadding * 2.0,
                    right: fixPadding * 2.0,
                    left: fixPadding * 2.0),
                padding: EdgeInsets.all(fixPadding * 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor,
                  border: Border.all(width: 0.2, color: primaryColor),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 1.5,
                      spreadRadius: 1.5,
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        color: primaryColor.withOpacity(0.2),
                      ),
                      child: Image.asset(
                        'assets/icons/courier.png',
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    widthSpace,
                    Container(
                      width: width - (fixPadding * 8.0 + 70.0 + 10.0 + 0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Get a ride',
                              style: primaryColorHeadingTextStyle),
                          Text('Go anywhere any time.',
                              style: greySmallTextStyle)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Food Deliver Start

          // Grocery Deliver Start
          // InkWell(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => GetGroceryDeliver()));
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(
          //         top: fixPadding * 2.0,
          //         right: fixPadding * 2.0,
          //         left: fixPadding * 2.0),
          //     padding: EdgeInsets.all(fixPadding * 2.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10.0),
          //       color: whiteColor,
          //       border: Border.all(width: 0.2, color: primaryColor),
          //       boxShadow: <BoxShadow>[
          //         BoxShadow(
          //           blurRadius: 1.5,
          //           spreadRadius: 1.5,
          //           color: primaryColor.withOpacity(0.2),
          //         ),
          //       ],
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           width: 70.0,
          //           height: 70.0,
          //           alignment: Alignment.center,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(35.0),
          //             color: primaryColor.withOpacity(0.2),
          //           ),
          //           child: Image.asset(
          //             'assets/icons/grocery.png',
          //             width: 40.0,
          //             height: 40.0,
          //             fit: BoxFit.fitHeight,
          //           ),
          //         ),
          //         widthSpace,
          //         Container(
          //           width: width - (fixPadding * 8.0 + 70.0 + 10.0 + 0.4),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text('Get Grocery Deliver',
          //                   style: primaryColorHeadingTextStyle),
          //               Text(
          //                   'Order grocery at your favourite store and we will deliver it.',
          //                   style: greySmallTextStyle)
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // Grocery Deliver Start
          // Courier Type End
          heightSpace,
          heightSpace,
        ],
      ),
    );
  }
}
