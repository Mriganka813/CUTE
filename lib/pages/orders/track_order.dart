// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cute/services/page_services/trip_info.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:cute/constant/constant.dart';
import 'package:cute/model/Input/order.dart';
import 'package:cute/pages/courier/route_map.dart';

import '../../services/const.dart';

class TrackOrder extends StatefulWidget {
  Order order;
  TrackOrder({
    Key? key,
    required this.order,
  }) : super(key: key);
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  late IO.Socket socket;
  late Set<String> notifications;
  @override
  void initState() {
    super.initState();
    connect();
    if (widget.order.status == 'STARTED') {
      notifications = Set<String>();
      notifications.add('Your trip has been started.');
    } else
      notifications = Set<String>();
  }

  /// Socket.io connection
  ///
  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;
    print(token);
    print(widget.order.customerSocketID);

    final socket = IO.io(Const.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        'accessToken': '$token',
        'isReconnect': false,
        'previousId': widget.order.customerSocketID,
        'role': 'CUSTOMER'
      }
    });
    setState(() {
      this.socket = socket;
    });

    // success
    socket.on('success', (data) {
      print(data);
    });

    // Driver location
    socket.on('driverLocation', (data) => print(data));

    // trip status
    socket.on('tripStatus', (data) => print(data));

    // driver at pickup
    socket.on('driverAtPickup', (data) {
      print(data);
      setState(() {
        notifications.add(data);
      });
    });

    // trip started
    socket.on('tripStarted', (data) {
      print(data);
      setState(() {
        notifications.add(data);
      });
    });

    // trip completed
    socket.on('tripCompleted', (data) {
      print(data);
      setState(() {
        notifications.add(data);
      });
    });

    socket.onError((data) => print(data));
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    endrideDialogue() {
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
              height: 200.0,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Are you sure you want to end the ride?",
                    style: blackHeadingTextStyle,
                  ),
                  const SizedBox(
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
                          padding: const EdgeInsets.all(10.0),
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
                          TripInfo trip = TripInfo();
                          await trip.endRide(widget.order.tripID!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
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

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track order',
              style: appBarBlackTextStyle,
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomSheet: Wrap(
        children: [
          Material(
            elevation: 7.0,
            color: whiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.query_stats_rounded,
                              color: greyColor, size: 25.0),
                          widthSpace,
                          Text(widget.order.status!,
                              style: blackHeadingTextStyle),
                        ],
                      ),
                      // widthSpace,
                      // TextButton(
                      //     onPressed: () {
                      //       connect();
                      //     },
                      //     child: Icon(Icons.abc)),
                      // widthSpace,
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          strokeWidth: 1.2,
                          color: greyColor.withOpacity(0.6),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              // width: 200.0,
                              padding: EdgeInsets.all(fixPadding),
                              decoration: BoxDecoration(color: whiteColor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {},
                                      child: Text(
                                        'OTP : ',
                                        style: primaryColorHeadingTextStyle,
                                      )),
                                  Text(
                                    widget.order.otp!,
                                    textScaleFactor: 1.2,
                                    // style: primaryColorSmallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Text(
                      //   'Delivery by',
                      //   style: greyNormalTextStyle,
                      // ),
                      // SizedBox(width: 5.0),
                      // Text(
                      //   '4:10 PM',
                      //   style: blackLargeTextStyle,
                      // ),
                    ],
                  ),
                ),
                getDevider(),
                Container(
                  padding: EdgeInsets.only(
                      left: fixPadding * 2.0, right: fixPadding * 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 2.0,
                                height: 30.0,
                                color: primaryColor,
                              ),
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
                              DottedLine(
                                direction: Axis.vertical,
                                lineLength: 50.0,
                                lineThickness: 2.0,
                                dashLength: 4.0,
                                dashColor: primaryColor,
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                            ],
                          ),
                          widthSpace,
                          SizedBox(
                            width:
                                width - (fixPadding * 4.0 + 10.0 + 30.0 + 50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<Set<String>>(
                                    stream: Stream.value(notifications),
                                    builder: (context,
                                        AsyncSnapshot<Set<String>> snapshot) {
                                      if (snapshot.hasData) {
                                        Set<String>? updatedList =
                                            snapshot.data;

                                        if (updatedList!.length > 0) {
                                          return SizedBox(
                                            height: 60,
                                            child: ListView.builder(
                                              itemCount: updatedList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SizedBox(
                                                  height: 60,
                                                  child: Text(
                                                    updatedList.elementAt(
                                                        updatedList.length -
                                                            index -
                                                            1),
                                                    style:
                                                        blackHeadingTextStyle,
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                          // Text(
                                          //   updatedList.last,
                                          //   style: blackHeadingTextStyle,
                                          // );
                                        } else {
                                          notifications.add(
                                              'Driver arriving at your location. \nPlease wait...');
                                        }
                                        return Text(
                                          'Driver arriving at your location. \nPlease wait...',
                                          style: blackHeadingTextStyle,
                                        );
                                      } else {
                                        return Text(
                                          'Driver arriving at your location.\nPlease wait...',
                                          style: blackHeadingTextStyle,
                                        );
                                      }
                                    }),
                                // child: Text(
                                //   'Items have been picked up',
                                //   style: blackHeadingTextStyle,
                                // ),

                                // Text(
                                //   'Partner have been picked up your items and is on his way to the delivery location',
                                //   style: greySmallTextStyle,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          color: greyColor, size: 24.0),
                    ],
                  ),
                ),
                getDevider(),
                // Container(
                //   padding: EdgeInsets.all(fixPadding * 2.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Container(
                //             width: 50.0,
                //             height: 50.0,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(25.0),
                //               image: DecorationImage(
                //                 image: AssetImage('assets/delivery_boy.jpg'),
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //           ),
                //           widthSpace,
                //           Text(
                //             'Peter Jones',
                //             style: blackLargeTextStyle,
                //           ),
                //         ],
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           IconButton(
                //             icon: Icon(Icons.chat_bubble_outline,
                //                 color: greyColor, size: 28.0),
                //             onPressed: () {},
                //           ),
                //           IconButton(
                //             icon:
                //                 Icon(Icons.call, color: greyColor, size: 28.0),
                //             onPressed: () {},
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                getDevider(),
                Container(
                  padding: EdgeInsets.all(fixPadding * 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹ ${widget.order.price!.toStringAsFixed(2)}',
                            style: blackHeadingTextStyle,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       'Order Details',
                          //       style: blueSmallTextStyle,
                          //     ),
                          //     SizedBox(width: 3.0),
                          //     Icon(Icons.arrow_forward_ios,
                          //         size: 10.0, color: greyColor),
                          //   ],
                          // ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Paid successfully',
                      //       style: greySmallTextStyle,
                      //     ),
                      //     SizedBox(width: 5.0),
                      //     Container(
                      //       width: 30.0,
                      //       height: 30.0,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15.0),
                      //         color: Colors.deepPurple.withOpacity(0.16),
                      //       ),
                      //       child: Icon(Icons.check,
                      //           color: Colors.deepPurple, size: 18.0),
                      //     ),
                      //   ],
                      // ),
                      InkWell(
                        onTap: () {
                          endrideDialogue();
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
                              color: primaryColor),
                          child: Text(
                            'End Ride',
                            style: whiteBottonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RouteMap(
          sourceLat: double.parse(widget.order.pickup_lat!),
          sourceLang: double.parse(widget.order.pickup_long!),
          destinationLat: double.parse(widget.order.drop_lat!),
          destinationLang: double.parse(widget.order.drop_long!),
          driverLat: double.parse(widget.order.driver_lat!),
          driverLang: double.parse(widget.order.driver_long!),
          socket: socket),
    );
  }

  getDevider() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 1.0,
      color: Colors.grey[200],
    );
  }
}
