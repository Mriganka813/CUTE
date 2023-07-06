import 'package:cute/constant/constant.dart';
import 'package:cute/constant/custom_snackbar.dart';
import 'package:cute/constant/key.dart';
import 'package:cute/model/Input/NewTripInput.dart';
import 'package:cute/model/Input/vehicle.dart';
import 'package:cute/pages/courier/route_map.dart';
import 'package:cute/pages/payment/payment.dart';
import 'package:cute/services/page_services/trip_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendPackages extends StatefulWidget {
  final LatLng kInitialPosition;

  const SendPackages({Key? key, required this.kInitialPosition})
      : super(key: key);
  @override
  _SendPackagesState createState() => _SendPackagesState();
}

class _SendPackagesState extends State<SendPackages> {
  // For Screens
  bool packageTypeScreen = false;
  bool packageSizeWeightScreen = false;
  bool selectPickUpAddressScreen = true;
  bool selectDeliveryAddressScreen = false;
  bool confirmScreen = false;

  // For Package Type
  bool documents = false, parcel = false;

  // For Package Size and Weight Screen
  bool height = false, widthInput = false, depth = false, weight = false;
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  final depthController = TextEditingController();
  final weightController = TextEditingController();

  // For Pickup Address Screen
  var pickuplocation;
  PickResult? selectedPickupPlace;
  final pickupAddressController = TextEditingController();
  bool pickupAddress = false;

  // For Delivery Address Screen
  var droplocatioon;
  PickResult? selectedDeliveryPlace;
  final deliveryAddressController = TextEditingController();
  bool deliveryAddress = false;

  // Calculate Distance Between two Locations
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a)));
  }

  @override
  void initState() {
    super.initState();
    pickuplocation = {
      widget.kInitialPosition.latitude,
      widget.kInitialPosition.longitude
    };
    droplocatioon = {
      widget.kInitialPosition.latitude,
      widget.kInitialPosition.longitude
    };
  }

  int _selectedVehical = -1;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("lat : " + widget.kInitialPosition.latitude.toString());
    print("long : " + widget.kInitialPosition.longitude.toString());

    return Hero(
      tag: 'Send Packages',
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          titleSpacing: 0.0,
          title: Text(
              (packageTypeScreen)
                  ? 'Select Package Type'
                  : (packageSizeWeightScreen)
                      ? 'Enter Package Size and Weight'
                      : (selectPickUpAddressScreen)
                          ? 'Select Pickup Address'
                          : (selectDeliveryAddressScreen)
                              ? 'Select Delivery Address'
                              : (confirmScreen)
                                  ? 'Confirm Details'
                                  : '',
              style: appBarBlackTextStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: blackColor),
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
              child:
                  // (packageTypeScreen)
                  //     ? selectPackageTypeScreen()
                  //     : (packageSizeWeightScreen)
                  //         ? enterPackageSizeWeightScreen()
                  //         :
                  (selectPickUpAddressScreen)
                      ? selectPickupAddressScreenCode()
                      : (selectDeliveryAddressScreen)
                          ? selectDeliveryAddressScreenCode()
                          : (confirmScreen)
                              ? confirmScreenCode()
                              : Container(),
            ),
            // Container(
            //   width: width,
            //   height: 85.0,
            //   color: whiteColor,
            //   alignment: Alignment.center,
            //   padding: EdgeInsets.all(fixPadding * 2.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       (packageTypeScreen || selectPickUpAddressScreen)
            //           ? Container()
            //           : backButton(),
            //       continueButton(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  selectPackageTypeScreen() {
    double width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // For Document Start
              InkWell(
                onTap: () {
                  setState(() {
                    documents = true;
                    parcel = false;
                  });
                },
                child: Container(
                  width: (width - (fixPadding * 6.0)) / 2.0,
                  child: Column(
                    children: [
                      Container(
                        width: (width - (fixPadding * 6.0)) / 2.0,
                        padding: EdgeInsets.only(
                            top: fixPadding * 2.0, bottom: fixPadding * 2.0),
                        decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              width: 0.8,
                              color: (documents)
                                  ? primaryColor
                                  : greyColor.withOpacity(0.2)),
                        ),
                        child: Container(
                          width: (width - (fixPadding * 6.0)) / 2.0,
                          padding: EdgeInsets.only(right: fixPadding * 2.0),
                          height: 170.0,
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/icons/document_type.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child: Container(
                            width: 26.0,
                            height: 26.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: (documents) ? primaryColor : greyColor,
                              borderRadius: BorderRadius.circular(13.0),
                              border: Border.all(
                                  width: 1.0,
                                  color:
                                      (documents) ? primaryColor : greyColor),
                            ),
                            child: Icon(Icons.check,
                                color: (documents) ? whiteColor : greyColor,
                                size: 18.0),
                          ),
                        ),
                      ),
                      heightSpace,
                      Text(
                        'Documents',
                        style: blackLargeTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              // For Document End

              // For Parcel Start
              InkWell(
                onTap: () {
                  setState(() {
                    documents = false;
                    parcel = true;
                  });
                },
                child: Container(
                  width: (width - (fixPadding * 6.0)) / 2.0,
                  child: Column(
                    children: [
                      Container(
                        width: (width - (fixPadding * 6.0)) / 2.0,
                        padding: EdgeInsets.only(
                            top: fixPadding * 2.0, bottom: fixPadding * 2.0),
                        decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              width: 0.8,
                              color: (parcel)
                                  ? primaryColor
                                  : greyColor.withOpacity(0.2)),
                        ),
                        child: Container(
                          width: (width - (fixPadding * 6.0)) / 2.0,
                          padding: EdgeInsets.only(right: fixPadding * 2.0),
                          height: 170.0,
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/parcel_type.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child: Container(
                            width: 26.0,
                            height: 26.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: (parcel) ? primaryColor : greyColor,
                              borderRadius: BorderRadius.circular(13.0),
                              border: Border.all(
                                  width: 1.0,
                                  color: (parcel) ? primaryColor : greyColor),
                            ),
                            child: Icon(Icons.check,
                                color: (parcel) ? whiteColor : greyColor,
                                size: 18.0),
                          ),
                        ),
                      ),
                      heightSpace,
                      Text(
                        'Parcel',
                        style: blackLargeTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              // For Parcel End
            ],
          ),
        ),
      ],
    );
  }

  enterPackageSizeWeightScreen() {
    double width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Height Start
              Text('Height', style: primaryColorHeadingTextStyle),
              heightSpace,
              Container(
                width: width - (fixPadding * 4.0),
                height: 50.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border:
                      Border.all(width: 0.8, color: greyColor.withOpacity(0.6)),
                ),
                child: TextField(
                  style: inputTextStyle,
                  keyboardType: TextInputType.number,
                  controller: heightController,
                  decoration: InputDecoration(
                    hintText: 'Please Enter Package Height in cm',
                    hintStyle: inputTextStyle,
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (v) {
                    if (heightController.text != '') {
                      setState(() {
                        height = true;
                      });
                    } else {
                      setState(() {
                        height = false;
                      });
                    }
                  },
                ),
              ),
              heightSpace,
              Text('Enter height in cm', style: infoTextStyle),
              // Height End
              heightSpace,
              heightSpace,
              // Width Start
              Text('Width', style: primaryColorHeadingTextStyle),
              heightSpace,
              Container(
                width: width - (fixPadding * 4.0),
                height: 50.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border:
                      Border.all(width: 0.8, color: greyColor.withOpacity(0.6)),
                ),
                child: TextField(
                  style: inputTextStyle,
                  keyboardType: TextInputType.number,
                  controller: widthController,
                  decoration: InputDecoration(
                    hintText: 'Please Enter Package Width in cm',
                    hintStyle: inputTextStyle,
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (v) {
                    if (widthController.text != '') {
                      setState(() {
                        widthInput = true;
                      });
                    } else {
                      setState(() {
                        widthInput = false;
                      });
                    }
                  },
                ),
              ),
              heightSpace,
              Text('Enter width in cm', style: infoTextStyle),
              // Width End
              heightSpace,
              heightSpace,
              // Depth Start
              Text('Depth', style: primaryColorHeadingTextStyle),
              heightSpace,
              Container(
                width: width - (fixPadding * 4.0),
                height: 50.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border:
                      Border.all(width: 0.8, color: greyColor.withOpacity(0.6)),
                ),
                child: TextField(
                  style: inputTextStyle,
                  keyboardType: TextInputType.number,
                  controller: depthController,
                  decoration: InputDecoration(
                    hintText: 'Please Enter Package Depth in cm',
                    hintStyle: inputTextStyle,
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (v) {
                    if (depthController.text != '') {
                      setState(() {
                        depth = true;
                      });
                    } else {
                      setState(() {
                        depth = false;
                      });
                    }
                  },
                ),
              ),
              heightSpace,
              Text('Enter depth in cm', style: infoTextStyle),
              // Depth End
              heightSpace,
              heightSpace,
              // Weight Start
              Text('Weight', style: primaryColorHeadingTextStyle),
              heightSpace,
              Container(
                width: width - (fixPadding * 4.0),
                height: 50.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border:
                      Border.all(width: 0.8, color: greyColor.withOpacity(0.6)),
                ),
                child: TextField(
                  style: inputTextStyle,
                  keyboardType: TextInputType.number,
                  controller: weightController,
                  decoration: InputDecoration(
                    hintText: 'Please Enter Package Weight in kg',
                    hintStyle: inputTextStyle,
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (v) {
                    if (weightController.text != '') {
                      setState(() {
                        weight = true;
                      });
                    } else {
                      setState(() {
                        weight = false;
                      });
                    }
                  },
                ),
              ),
              heightSpace,
              Text('Enter weight in kg', style: infoTextStyle),
              // Weight End
            ],
          ),
        ),
      ],
    );
  }

  // Pickup Address Screen Start
  selectPickupAddressScreenCode() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Container(
          width: width,
          // height: height - 85.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    // color: Colors.amber,
                    height: height / 1.1,
                    child: PlacePicker(
                      apiKey: googleMapKey,
                      initialPosition: widget.kInitialPosition,
                      useCurrentLocation: true,
                      selectInitialPosition: true,
                      automaticallyImplyAppBarLeading: false,
                      hintText: "Search",
                      // usePlaceDetailSearch: true,
                      // onPlacePicked: (result) {
                      //   selectedPickupPlace = result;
                      //   Navigator.of(context).pop();
                      //   setState(() {
                      //     selectedPickupPlace = result;
                      //   });
                      // },
                      selectedPlaceWidgetBuilder:
                          (_, selectedPlace, state, isSearchBarFocused) {
                        return isSearchBarFocused
                            ? Container()
                            : FloatingCard(
                                bottomPosition: height / 15,
                                color: Colors.transparent,
                                leftPosition: width / 12,
                                // rightPosition: 0.0,
                                width: width / 1.2,
                                borderRadius: BorderRadius.circular(12.0),
                                child: state == SearchingState.Searching
                                    ? Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        child: Text("Select pickup location",
                                            style: TextStyle(fontSize: 20)),
                                        onPressed: () {
                                          print(pickuplocation);
                                          // Navigator.pop(context, selectedPlace);
                                          setState(() {
                                            selectedPickupPlace = selectedPlace;
                                            pickuplocation = selectedPlace!
                                                .geometry!.location
                                                .toJson();
                                            selectPickUpAddressScreen = false;
                                            selectDeliveryAddressScreen = true;
                                            customloadingDialog(
                                                "Please wait...");
                                          });
                                        },
                                      ),
                              );
                      },
                    )),
                // Container(
                //   padding: EdgeInsets.all(fixPadding * 2.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text('Place marker on google map at pickup location',
                //           style: greySmallTextStyle),
                //       heightSpace,
                //       (selectedPickupPlace == null)
                //           ? Container()
                //           : Text(
                //               selectedPickupPlace!.formattedAddress ?? "",
                //               textAlign: TextAlign.center,
                //               style: inputTextStyle,
                //             ),
                //       (selectedPickupPlace == null) ? Container() : heightSpace,
                //       Text('Pickup Address',
                //           style: primaryColorHeadingTextStyle),
                //       heightSpace,
                //       Container(
                //         width: width - (fixPadding * 4.0),
                //         height: 120.0,
                //         alignment: Alignment.centerLeft,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(5.0),
                //           border: Border.all(
                //               width: 0.8, color: greyColor.withOpacity(0.6)),
                //         ),
                //         child: TextField(
                //           style: inputTextStyle,
                //           keyboardType: TextInputType.multiline,
                //           maxLines: 3,
                //           controller: pickupAddressController,
                //           decoration: InputDecoration(
                //             hintText:
                //                 'Please enter exact pickup address like house no, flat no, road no, etc.',
                //             hintStyle: TextStyle(color: Colors.grey),
                //             contentPadding: EdgeInsets.all(10.0),
                //             border: InputBorder.none,
                //           ),
                //           onChanged: (v) {
                //             if (pickupAddressController.text != '') {
                //               setState(() {
                //                 pickupAddress = true;
                //               });
                //             } else {
                //               setState(() {
                //                 pickupAddress = false;
                //               });
                //             }
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // Pickup Address Screen End

  // Delivery Address Screen Start
  selectDeliveryAddressScreenCode() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Container(
          width: width,
          // height: height - 85.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: height / 1.1,
                  child: PlacePicker(
                    apiKey: googleMapKey,
                    initialPosition: widget.kInitialPosition,
                    useCurrentLocation: true,
                    selectInitialPosition: true,

                    automaticallyImplyAppBarLeading: false,
                    hintText: "Search",
                    //usePlaceDetailSearch: true,
                    // onPlacePicked: (result) {
                    //   selectedDeliveryPlace = result;
                    //   Navigator.of(context).pop();
                    //   setState(() {});
                    // },
                    selectedPlaceWidgetBuilder:
                        (_, selectedPlace, state, isSearchBarFocused) {
                      return isSearchBarFocused
                          ? Container()
                          : FloatingCard(
                              bottomPosition: height / 15,
                              color: Colors.transparent,
                              leftPosition: width / 12,
                              // rightPosition: 0.0,
                              width: width / 1.2,
                              borderRadius: BorderRadius.circular(12.0),
                              child: state == SearchingState.Searching
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                      child: Text("Select drop location",
                                          style: TextStyle(fontSize: 20)),
                                      onPressed: () async {
                                        // Navigator.pop(context, selectedPlace);
                                        setState(() {
                                          selectedDeliveryPlace = selectedPlace;
                                          droplocatioon = selectedPlace!
                                              .geometry!.location
                                              .toJson();
                                        });
                                        await getVehicleList();
                                        setState(() {
                                          selectDeliveryAddressScreen = false;
                                          confirmScreen = true;
                                        });
                                      },
                                    ),
                            );
                    },
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(fixPadding * 2.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text('Place marker on google map at delivery location',
                //           style: greySmallTextStyle),
                //       heightSpace,
                //       (selectedDeliveryPlace == null)
                //           ? Container()
                //           : Text(
                //               selectedDeliveryPlace!.formattedAddress ?? "",
                //               textAlign: TextAlign.center,
                //               style: inputTextStyle,
                //             ),
                //       (selectedDeliveryPlace == null)
                //           ? Container()
                //           : heightSpace,
                //       Text('Delivery Address',
                //           style: primaryColorHeadingTextStyle),
                //       heightSpace,
                //       Container(
                //         width: width - (fixPadding * 4.0),
                //         height: 120.0,
                //         alignment: Alignment.centerLeft,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(5.0),
                //           border: Border.all(
                //               width: 0.8, color: greyColor.withOpacity(0.6)),
                //         ),
                //         child: TextField(
                //           style: inputTextStyle,
                //           keyboardType: TextInputType.multiline,
                //           maxLines: 3,
                //           controller: deliveryAddressController,
                //           decoration: InputDecoration(
                //             hintText: 'Please enter exact pickup address',
                //             hintStyle: inputTextStyle,
                //             contentPadding: EdgeInsets.all(10.0),
                //             border: InputBorder.none,
                //           ),
                //           onChanged: (v) {
                //             if (deliveryAddressController.text != '') {
                //               setState(() {
                //                 deliveryAddress = true;
                //               });
                //             } else {
                //               setState(() {
                //                 deliveryAddress = false;
                //               });
                //             }
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Delivery Address Screen End
  Vehicle _selectedVehicle = Vehicle();
  NewTripInput _newTrip = NewTripInput();

  // Confirm Screen Start
  confirmScreenCode() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // bottomSheet: Wrap(
      //   children: [
      //     Material(
      //       elevation: 7.0,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(
      //                 right: fixPadding * 2.0,
      //                 left: fixPadding * 2.0,
      //                 top: fixPadding),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 // Pickup Start
      //                 Container(
      //                   width: (width - (fixPadding * 6.0)) / 2.0,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'Pickup',
      //                         style: blackLargeTextStyle,
      //                       ),
      //                       heightSpace,
      //                       Text(pickupAddressController.text,
      //                           style: inputTextStyle),
      //                     ],
      //                   ),
      //                 ),
      //                 // Pickup End
      //                 // Delivery Start
      //                 Container(
      //                   width: (width - (fixPadding * 6.0)) / 2.0,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'Delivery',
      //                         style: blackLargeTextStyle,
      //                       ),
      //                       heightSpace,
      //                       Text(deliveryAddressController.text,
      //                           style: inputTextStyle),
      //                     ],
      //                   ),
      //                 ),
      //                 // Delivery End
      //               ],
      //             ),
      //           ),
      //           Divider(),
      //           // Padding(
      //           //   padding: EdgeInsets.only(
      //           //       right: fixPadding * 2.0,
      //           //       left: fixPadding * 2.0,
      //           //       bottom: fixPadding),
      //           //   child: Row(
      //           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           //     crossAxisAlignment: CrossAxisAlignment.start,
      //           //     children: [
      //           //       // Size Start
      //           //       Container(
      //           //         width: (width - (fixPadding * 6.0)) / 2.0,
      //           //         child: Column(
      //           //           mainAxisAlignment: MainAxisAlignment.start,
      //           //           crossAxisAlignment: CrossAxisAlignment.start,
      //           //           children: [
      //           //             Text(
      //           //               'Size',
      //           //               style: blackLargeTextStyle,
      //           //             ),
      //           //             heightSpace,
      //           //             Text(
      //           //                 '${heightController.text} x ${widthController.text} x ${depthController.text} cm',
      //           //                 style: inputTextStyle),
      //           //           ],
      //           //         ),
      //           //       ),
      //           //       // Size End
      //           //       // Weight Start
      //           //       Container(
      //           //         width: (width - (fixPadding * 6.0)) / 2.0,
      //           //         child: Column(
      //           //           mainAxisAlignment: MainAxisAlignment.start,
      //           //           crossAxisAlignment: CrossAxisAlignment.start,
      //           //           children: [
      //           //             Text(
      //           //               'Weight',
      //           //               style: blackLargeTextStyle,
      //           //             ),
      //           //             heightSpace,
      //           //             Text('${weightController.text} kg',
      //           //                 style: inputTextStyle),
      //           //           ],
      //           //         ),
      //           //       ),
      //           //       // Weight End
      //           //     ],
      //           //   ),
      //           // ),
      //           Container(
      //             color: lightPrimaryColor,
      //             padding: EdgeInsets.all(fixPadding),
      //             alignment: Alignment.center,
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Text(
      //                     'Distance: ${(calculateDistance(selectedPickupPlace!.geometry!.location.lat, selectedPickupPlace!.geometry!.location.lng, selectedDeliveryPlace!.geometry!.location.lat, selectedDeliveryPlace!.geometry!.location.lng)).toStringAsFixed(2)} km',
      //                     style: primaryColorHeadingTextStyle),
      //                 // SizedBox(height: 5.0),
      //                 // Text('Price: \$15', style: primaryColorHeadingTextStyle),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: height / 3,
                child: RouteMap(
                    sourceLat: selectedPickupPlace!.geometry!.location.lat,
                    sourceLang: selectedPickupPlace!.geometry!.location.lng,
                    destinationLat:
                        selectedDeliveryPlace!.geometry!.location.lat,
                    destinationLang:
                        selectedDeliveryPlace!.geometry!.location.lng),
              ),
              InkWell(
                onTap: () async {
                  TripInfo tripdetail = new TripInfo();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  tripdetail.getVehicalList(prefs.getString('access_token'),
                      pickuplocation, droplocatioon);
                },
                child: Container(
                    child: Text("Choose your vehicle",
                        style: primaryColorHeadingTextStyle)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Container(
                  height: height / 3.9,
                  child: ListView.builder(
                    itemCount: vehicleList.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text('${vehicleList[index].vehicleType}',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle:
                            Text('\₹ ${vehicleList[index].pricePerKM} / km'),
                        leading: Icon(Icons.local_taxi),
                        // leading: CircleAvatar(
                        //   backgroundImage:
                        //       AssetImage('assets/delivery_boy.jpg'),
                        // ),
                        tileColor: _selectedVehical == -1
                            ? Colors.white
                            : _selectedVehical == index
                                ? primaryColor.withOpacity(0.1)
                                : Colors.white,
                        trailing: Text('Available'),
                        onTap: () {
                          setState(() {
                            // _selectedVehicle = vehicleList[index];
                            _selectedVehical = index;
                            _newTrip.serviceAreaId =
                                vehicleList[index].serviceAreaID;
                            _newTrip.vehicleId = vehicleList[index].vehicleId;
                            _newTrip.price = vehicleList[index].price;
                            _newTrip.pickuplocation = pickuplocation;
                            _newTrip.droplocatioon = droplocatioon;
                          });
                          // print(_newTrip.serviceAreaId);
                          // print(_newTrip.price);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: height / 4,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 10),
          child: Column(
            children: [
              Divider(),
              Container(
                color: primaryColor.withOpacity(0.2),
                height: height / 11,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          'Distance: ${vehicleList[vehicleList.length - 1].distance!.toStringAsFixed(2)} km',
                          // 'Distance: ${(calculateDistance(selectedPickupPlace!.geometry!.location.lat, selectedPickupPlace!.geometry!.location.lng, selectedDeliveryPlace!.geometry!.location.lat, selectedDeliveryPlace!.geometry!.location.lng)).toStringAsFixed(2)} km',
                          style: primaryColorHeadingTextStyle),
                      SizedBox(height: 5.0),
                      _newTrip.price == null
                          ? Text('Price: \₹0.00',
                              style: primaryColorHeadingTextStyle)
                          : Text(
                              'Price: \₹${_newTrip.price!.toStringAsFixed(2)}',
                              style: primaryColorHeadingTextStyle),
                    ],
                  ),
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [backButton(), continueButton()],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Confirm Screen End

  // Back Button Start
  backButton() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (packageSizeWeightScreen) {
          setState(() {
            packageTypeScreen = true;
            packageSizeWeightScreen = false;
          });
        }
        if (selectPickUpAddressScreen) {
          setState(() {
            selectPickUpAddressScreen = false;
            packageSizeWeightScreen = true;
          });
        }

        if (selectDeliveryAddressScreen) {
          setState(() {
            selectDeliveryAddressScreen = false;
            selectPickUpAddressScreen = true;
          });
        }

        if (confirmScreen) {
          setState(() {
            confirmScreen = false;
            selectDeliveryAddressScreen = true;
          });
        }
      },
      child: Container(
        width: (width - (fixPadding * 6.0)) / 2.0,
        padding: EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 1.0, color: blackColor),
        ),
        child: Text('Back', style: blackLargeTextStyle),
      ),
    );
  }

  // Back Button End
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
                Text('Getting all drivers near you...',
                    style: greySmallTextStyle),
              ],
            ),
          ),
        );
      },
    );
  }

  customloadingDialog(String value) {
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
                Text(value, style: greySmallTextStyle),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  List<Vehicle> vehicleList = [];
  getVehicleList() async {
    loadingDialog();
    TripInfo tripdetail = new TripInfo();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    vehicleList = await tripdetail.getVehicalList(
        prefs.getString('access_token'), pickuplocation, droplocatioon);
    print(vehicleList);
    Navigator.pop(context, true);
  }

  // Continue Button Start
  continueButton() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        print("object");
        if (selectPickUpAddressScreen) {
          // if (pickupAddress && selectedPickupPlace != null) {
          setState(() {
            selectPickUpAddressScreen = false;
            selectDeliveryAddressScreen = true;
          });
          // }
        } else if (selectDeliveryAddressScreen) {
          if (deliveryAddress && selectedDeliveryPlace != null) {
            await getVehicleList();
            setState(() {
              selectDeliveryAddressScreen = false;
              confirmScreen = true;
            });
          }
        } else if (confirmScreen) {
          if (_selectedVehical == -1) {
            // SnackBarWidget.showErrorBar(context, "Please select vehicle");
            Fluttertoast.showToast(
                msg: "Please select vehicle",
                backgroundColor: Colors.red,
                textColor: whiteColor,
                fontSize: 16.0);
          } else {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: Payment(input: _newTrip)));
          }
        }
      },
      child: Container(
        width: (width - (fixPadding * 6.0)) / 2.0,
        padding: EdgeInsets.all(fixPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            width: 1.0,
            color: (packageTypeScreen)
                ? (documents || parcel)
                    ? primaryColor
                    : greyColor
                : (packageSizeWeightScreen)
                    ? (height && widthInput && depth && weight)
                        ? primaryColor
                        : greyColor
                    : (selectPickUpAddressScreen)
                        ? (pickupAddress && selectedPickupPlace != null)
                            ? primaryColor
                            : greyColor
                        : (selectDeliveryAddressScreen)
                            ? (deliveryAddress && selectedDeliveryPlace != null)
                                ? primaryColor
                                : greyColor
                            : (confirmScreen)
                                ? primaryColor
                                : greyColor,
          ),
          color: (packageTypeScreen)
              ? (documents || parcel)
                  ? primaryColor
                  : greyColor
              : (packageSizeWeightScreen)
                  ? (height && widthInput && depth && weight)
                      ? primaryColor
                      : greyColor
                  : (selectPickUpAddressScreen)
                      ? (pickupAddress && selectedPickupPlace != null)
                          ? primaryColor
                          : greyColor
                      : (selectDeliveryAddressScreen)
                          ? (deliveryAddress && selectedDeliveryPlace != null)
                              ? primaryColor
                              : greyColor
                          : (confirmScreen)
                              ? primaryColor
                              : greyColor,
        ),
        child: Text((confirmScreen) ? 'Pay' : 'Continue',
            style: whiteLargeTextStyle),
      ),
    );
  }
  // Continue Button End
}
