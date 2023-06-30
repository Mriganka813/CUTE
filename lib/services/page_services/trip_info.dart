import 'dart:convert';

import 'package:cute/model/Input/NewTripInput.dart';
import 'package:cute/model/Input/order.dart';
import 'package:cute/model/Input/vehicle.dart';
import 'package:cute/services/api_v1.dart';
import 'package:cute/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../const.dart';

class TripInfo {
  TripInfo();
  AuthService auth = new AuthService();

  // Vehicle List
  Future<List<Vehicle>> getVehicalList(token, pickup, drop) async {
    List<Vehicle> vehicle = [];
    String pickupLat = decodelocation(pickup, 0).toString();
    String pickupLong = decodelocation(pickup, 1).toString();
    String dropLat = decodelocation(drop, 0).toString();
    String dropLong = decodelocation(drop, 1).toString();

    await ApiV1Service.getRequest(
            '/trips/info/newtrip?pickupLat=$pickupLat&dropLat=$dropLat&pickupLong=$pickupLong&dropLong=$dropLong',
            token: token)
        .then((value) {
      print(value);
      final _vehicle = List.generate(
        value.data['vehicles'].length,
        (int index) => Vehicle.fromMap(
          value.data['vehicles'][index],
        ),
      );
      // _vehicle.add(value.data['distance']);
      // print(value.data['distance']);
      Vehicle dis_vehicle = Vehicle(distance: value.data['distance']);
      _vehicle.add(dis_vehicle);
      vehicle = _vehicle;
      print(vehicle);
    }).onError((error, stackTrace) {
      throw "No Service Available";
    });
    return vehicle;
  }

  Future<void> createTrip(NewTripInput input) async {
    print(input.toMap());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;
    print(token);

    await ApiV1Service.postRequest('/trips/confirmed/newtrip',
            data: input.toMap(), token: token)
        .catchError((e) {
      print(e);
      throw "New Trip has not been created";
    });

    // start socket for very first time to update socket id to database
    IO.Socket socket;
    socket = IO.io(Const.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'accessToken': '$token', 'role': 'CUSTOMER'}
    });

    // success
    socket.on('success', (data) {
      print(data);
    });
  }

  // index 0 = lat, index 1 = long
  decodelocation(location, int index) {
    Map<String, dynamic> loc = location;
    return loc.values.elementAt(index);
  }

  /// GET ALL TRIPS
  Future<List<Order>> getAllTrips(String orderType) async {
    List<Order> order = [];
    List<Order> _waitingorder = [];
    List<Order> _pastorder = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;

    await ApiV1Service.getRequest('/trips/info', token: token).then((value) {
      print(value);

      for (var i = 0; i < value.data['trips'].length; i++) {
        if (value.data['trips'][i]['status'] == "WAITING FOR DRIVER" ||
            value.data['trips'][i]['status'] == "CONFIRMED" ||
            value.data['trips'][i]['status'] == "STARTED") {
          _waitingorder.add(Order.fromMap(value.data['trips'][i]));
          // final _waitingorder = Order.waiting(value.data['trips'][i]);
        } else if (value.data['trips'][i]['status'] == "COMPLETED") {
          _pastorder.add(Order.fromMap(value.data['trips'][i]));
          // final _pastorder = Order.fromMap(value.data['trips'][i]);
        }
      }
      order = orderType == "activeOrder" ? _waitingorder : _pastorder;
    }).onError((error, stackTrace) {
      print(error);
      throw "No trips Available";
    });
    return order;
  }

  /// ALL TRIPS OF USER
  Future<List<Order>> getAllorders(String token) async {
    List<Order> orderhistory = [];
    await ApiV1Service.getRequest('/trips/info', token: token).then((value) {
      print(value);
      // print(value.data['trips'][0]);
      // print(value.data['trips'][0]['subTrips'][0]['start']['lat']);

      // if status == WAITING FOR DRIVER
      if (value.data['trips'][0]['status'] == "WAITING FOR DRIVER") {
        final _order = List.generate(
          value.data['trips'].length,
          (int index) => Order.fromMap(
            value.data['trips'][index],
          ),
        );
        // print(_order);
        orderhistory = _order;
      }

      // if status == CONFIRMED
      else if (value.data['trips'][0]['status'] == "CONFIRMED") {
        final _order = List.generate(
          value.data['trips'].length,
          (int index) => Order.fromMap(
            value.data['trips'][index],
          ),
        );
        // print(_order);
        orderhistory = _order;
      }

      // if status == STARTED
      else if (value.data['trips'][0]['status'] == "STARTED") {
        final _order = List.generate(
          value.data['trips'].length,
          (int index) => Order.fromMap(
            value.data['trips'][index],
          ),
        );
        // print(_order);
        orderhistory = _order;
      }

      // if status == COMPLETED
      else if (value.data['trips'][0]['status'] == "COMPLETED") {
        final _order = List.generate(
          value.data['trips'].length,
          (int index) => Order.fromMap(
            value.data['trips'][index],
          ),
        );
        // print(_order);
        orderhistory = _order;
      }
      // final _order = List.generate(
      //   value.data['trips'].length,
      //   (int index) => Order.waiting(
      //     value.data['trips'][index],
      //   ),
      // );
      // // print(_order);
      // orderhistory = _order;
      // print(_order[0].driver_lat);
      // print(_order[0].date);
      // print(_order[0].drop_lat);
      // print(_order[0].drop_long);
      // print(_order[0].pickup_lat);
      // print(_order[0].pickup_long);
      // print(_order[0].price);
      // print(_order[0].serviceAreaID);
      // print(_order[0].status);
      // print(_order[0].tripID);
      // print(_order[0].vehicleID);
    }).onError((error, stackTrace) {
      print(error);
      throw "No trips Available";
    });
    return orderhistory;
  }

  // END RIDE
  Future<void> endRide(String tripID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('access_token')!;
    print(token);
    await ApiV1Service.patchRequest(
            '/trips/confirmed/$tripID/complete/customer',
            token: token)
        .catchError((e) {
      print(e);
      throw "Service Unavailable";
    });
  }
}
