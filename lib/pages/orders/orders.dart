import 'dart:async';

import 'package:cute/constant/constant.dart';
import 'package:cute/model/Input/order.dart';
import 'package:cute/pages/orders/track_order.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cute/services/page_services/trip_info.dart';

class Orders extends StatefulWidget {
  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<Orders> {
  List<Order> orders = [];
  List<Order> PastOrders = [];
  bool isLoadingActiveOrder = true;
  bool isLoadingPastOrder = true;
  late var timer;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    if (mounted) {
      fetchOrders();
      timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
        fetchOrders();
      });
    } else {
      timer.cancel();
    }
    // print(orders[0].customerID);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;
    TripInfo tripInfo = TripInfo();
    // List<Order> _ActiveOrders = await tripInfo.getAllorders(token);
    List<Order> _ActiveOrders = await tripInfo.getAllTrips("activeOrder");
    List<Order> _PastOrders = await tripInfo.getAllTrips("pastOrder");

    setState(() {
      orders = _ActiveOrders;
      PastOrders = _PastOrders;
    });
    if (orders.length > 0) {
      setState(() {
        isLoadingActiveOrder = false;
      });
    }
    if (PastOrders.length > 0) {
      setState(() {
        isLoadingPastOrder = false;
      });
    }
  }

  getDate(String val) {
    DateTime dateTime = DateTime.parse(val);
    String res = dateTime.day.toString() +
        "-" +
        dateTime.month.toString() +
        "-" +
        dateTime.year.toString();
    return res;
  }

  gettime(String val) {
    DateTime dateTime = DateTime.parse(val);
    String res = dateTime.hour.toString() +
        ":" +
        dateTime.minute.toString() +
        ":" +
        dateTime.second.toString();
    return res;
  }

  Future<String> getCompleteAddress(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double long = double.parse(longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    Placemark placemark = placemarks.first;
    String address =
        '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    return address;
  }

  @override
  Widget build(BuildContext context) {
    // print(orders.length);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 1.0,
        title: Text(
          'Orders',
          style: appBarBlackTextStyle,
        ),
      ),
      body: ListView(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.only(
                top: fixPadding,
                bottom: fixPadding,
                right: fixPadding * 2.0,
                left: fixPadding * 2.0),
            color: Colors.grey[100],
            child: Text(
              'Active orders',
              style: blackSmallBoldTextStyle,
            ),
          ),
          orders.length > 0
              ? activeOrder()
              : Column(children: [
                  // SizedBox(height: 30),
                  // Visibility(
                  //     visible: isLoadingActiveOrder,
                  //     child: CircularProgressIndicator()),
                  // SizedBox(height: 30),
                  Text(
                    "No Active Orders",
                  ),
                ]),
          Container(
            width: width,
            padding: EdgeInsets.only(
                top: fixPadding,
                bottom: fixPadding,
                right: fixPadding * 2.0,
                left: fixPadding * 2.0),
            color: Colors.grey[100],
            child: Text(
              'Past orders',
              style: blackSmallBoldTextStyle,
            ),
          ),
          PastOrders.length > 0
              ? pastOrder()
              : Column(children: [
                  // SizedBox(height: 30),
                  // Visibility(
                  //     visible: isLoadingPastOrder,
                  //     child: CircularProgressIndicator()),
                  // SizedBox(height: 30),
                  Text(
                    "No Past Orders",
                  ),
                ]),
          // pastOrder(),
        ],
      ),
    );
  }

  cancelOrderDialog(String tripId) {
    double width = MediaQuery.of(context).size.width;
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
            height: 200.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Are you sure you want to cancel the ride?",
                  style: blackHeadingTextStyle,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: (width / 3.5),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'No',
                          style: blackBottonTextStyle,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        TripInfo trip = new TripInfo();
                        await trip.cancelRide(tripId);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: (width / 3.5),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Yes',
                          style: whiteBottonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  activeOrder() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      color: whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '#${orders[0].tripID}',
                            style: blackLargeTextStyle,
                          ),
                          IconButton(
                              onPressed: () {
                                cancelOrderDialog(orders[0].tripID!);
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ))
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Text(
                            getDate(orders[0].date!),
                            style: greySmallTextStyle,
                          ),
                          SizedBox(width: 10),
                          Text(
                            gettime(orders[0].date!),
                            style: greySmallTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // Icon(
              //   Icons.arrow_forward_ios,
              //   size: 18.0,
              //   color: greyColor,
              // ),
            ],
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: (width - (fixPadding * 6.0 + 6.0)) / 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30.0,
                      height: 30.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 1.0, color: blackColor),
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        size: 25.0,
                        color: blackColor,
                      ),
                    ),
                    widthSpace,
                    Container(
                      width: ((width - (fixPadding * 6.0 + 6.0)) / 2.0) -
                          30.0 -
                          10.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: blackSmallBoldTextStyle,
                          ),
                          // FUTUREBUILDER FOR ADDRESS
                          FutureBuilder<String>(
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: greySmallTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else {
                                return Text(
                                  "Loading",
                                  style: greySmallTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                            },
                            future: getCompleteAddress(
                                orders[0].pickup_lat!, orders[0].pickup_long!),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.0,
                height: 40.0,
                color: Colors.grey[300],
              ),
              Container(
                width: (width - (fixPadding * 6.0 + 6.0)) / 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30.0,
                      height: 30.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 1.0, color: blackColor),
                      ),
                      child: Icon(
                        Icons.arrow_downward,
                        size: 25.0,
                        color: blackColor,
                      ),
                    ),
                    widthSpace,
                    Container(
                      width: ((width - (fixPadding * 6.0 + 6.0)) / 2.0) -
                          30.0 -
                          10.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: blackSmallBoldTextStyle,
                          ),
                          // FUTUREBUILDER FOR ADDRESS
                          FutureBuilder<String>(
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: greySmallTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else {
                                return Text(
                                  "Loading",
                                  style: greySmallTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                            },
                            future: getCompleteAddress(
                                orders[0].drop_lat!, orders[0].drop_long!),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          heightSpace,
          heightSpace,
          Text(
            'Paid: \₹${orders[0].price!.toStringAsFixed(2)}',
            style: TextStyle(
              color: blackColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30.0,
                    height: 30.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: primaryColor.withOpacity(0.3),
                    ),
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: primaryColor,
                      ),
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                  widthSpace,
                  Text(
                    orders[0].status == 'WAITING FOR DRIVER'
                        ? 'Waiting for driver'
                        : orders[0].status == 'CONFIRMED'
                            ? 'Driver Confirmed'
                            : orders[0].status == 'STARTED'
                                ? 'Trip Started'
                                : 'Completed',
                    // "Waiting for driver",
                    // textScaleFactor: 0.9,
                    style: blackSmallBoldTextStyle,
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  print(orders[0].status);
                  if (orders[0].status != 'WAITING FOR DRIVER') {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: TrackOrder(
                              order: orders[0],
                            )));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            title: Text("Alert"),
                            content: Text("Driver has not been assigned yet"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: fixPadding * 0.7,
                    bottom: fixPadding * 0.7,
                    right: fixPadding * 3.0,
                    left: fixPadding * 3.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: orders[0].status != 'WAITING FOR DRIVER'
                        ? primaryColor
                        : Colors.grey[500],
                  ),
                  child: Text(
                    'Track order',
                    style: whiteBottonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pastOrder() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 1.5,
      child: ListView.builder(
        itemCount: PastOrders.length,
        shrinkWrap: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(fixPadding * 2.0),
            color: whiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'assets/icons/courier.png',
                        //   width: 50.0,
                        //   height: 50.0,
                        //   fit: BoxFit.fitHeight,
                        // ),
                        // widthSpace,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${PastOrders[index].tripID}',
                              style: blackLargeTextStyle,
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: [
                                Text(
                                  getDate(PastOrders[index].date!),
                                  style: greySmallTextStyle,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  gettime(PastOrders[index].date!),
                                  style: greySmallTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 18.0,
                    //   color: greyColor,
                    // ),
                  ],
                ),
                heightSpace,
                heightSpace,
                heightSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: (width - (fixPadding * 6.0 + 6.0)) / 2.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 30.0,
                            height: 30.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(width: 1.0, color: blackColor),
                            ),
                            child: Icon(
                              Icons.arrow_upward,
                              size: 25.0,
                              color: blackColor,
                            ),
                          ),
                          widthSpace,
                          Container(
                            width: ((width - (fixPadding * 6.0 + 6.0)) / 2.0) -
                                30.0 -
                                10.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From',
                                  style: blackSmallBoldTextStyle,
                                ),
                                // FUTUREBUILDER FOR ADDRESS
                                FutureBuilder<String>(
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data.toString(),
                                        style: greySmallTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    } else {
                                      return Text(
                                        "Loading",
                                        style: greySmallTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }
                                  },
                                  future: getCompleteAddress(
                                      PastOrders[index].pickup_lat!,
                                      PastOrders[index].pickup_long!),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.0,
                      height: 40.0,
                      color: Colors.grey[300],
                    ),
                    Container(
                      width: (width - (fixPadding * 6.0 + 6.0)) / 2.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 30.0,
                            height: 30.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(width: 1.0, color: blackColor),
                            ),
                            child: Icon(
                              Icons.arrow_downward,
                              size: 25.0,
                              color: blackColor,
                            ),
                          ),
                          widthSpace,
                          Container(
                            width: ((width - (fixPadding * 6.0 + 6.0)) / 2.0) -
                                30.0 -
                                10.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Work',
                                  style: blackSmallBoldTextStyle,
                                ),
                                // FUTUREBUILDER FOR ADDRESS
                                FutureBuilder<String>(
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data.toString(),
                                        style: greySmallTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    } else {
                                      return Text(
                                        "Loading",
                                        style: greySmallTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }
                                  },
                                  future: getCompleteAddress(
                                      PastOrders[index].drop_lat!,
                                      PastOrders[index].drop_long!),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                heightSpace,
                heightSpace,
                Text(
                  'Paid: \₹${PastOrders[index].price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                heightSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 22.0,
                          height: 22.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11.0),
                            color: primaryColor,
                          ),
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 14.0,
                          ),
                        ),
                        widthSpace,
                        Text(
                          'Completed',
                          style: blackSmallBoldTextStyle,
                        ),
                      ],
                    ),
                    // InkWell(
                    //   onTap: () {},
                    //   child: Container(
                    //     padding: EdgeInsets.only(
                    //       top: fixPadding * 0.7,
                    //       bottom: fixPadding * 0.7,
                    //       right: fixPadding * 3.0,
                    //       left: fixPadding * 3.0,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(40.0),
                    //       color: primaryColor,
                    //     ),
                    //     child: Text(
                    //       'Reorder',
                    //       style: whiteBottonTextStyle,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Divider(thickness: 2)
              ],
            ),
          );
        },
      ),
    );
  }
}
