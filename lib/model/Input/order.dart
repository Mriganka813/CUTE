// ignore_for_file: non_constant_identifier_names

class Order {
  Order({
    this.customerID,
    this.date,
    this.price,
    this.serviceAreaID,
    this.status,
    this.tripID,
    this.vehicleID,
    this.pickup_lat,
    this.pickup_long,
    this.drop_lat,
    this.drop_long,
    this.customerSocketID,
    this.driverSocketID,
    this.otp,
    this.driver_lat,
    this.driver_long,
  });

  String? pickup_lat;
  String? pickup_long;
  String? drop_lat;
  String? drop_long;

  String? driver_lat;
  String? driver_long;

  String? tripID;
  String? customerID;
  String? vehicleID;
  String? date;
  String? status;
  double? price;
  String? serviceAreaID;

  String? customerSocketID;
  String? driverSocketID;
  String? otp;

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        price: double.parse(json["price"].toString()),
        vehicleID: json["vehicleId"],
        pickup_lat: json["pickup"].values.elementAt(0).toString(),
        pickup_long: json["pickup"].values.elementAt(1).toString(),
        drop_lat: json["drop"].values.elementAt(0).toString(),
        drop_long: json["drop"].values.elementAt(1).toString(),
        status: json["status"],
        driver_lat: json["subTrips"].length == 0
            ? null
            : json["subTrips"][0]["start"]["lat"].toString(),
        driver_long: json["subTrips"].length == 0
            ? null
            : json["subTrips"][0]["start"]["long"].toString(),
        tripID: json["_id"],
        customerID: json["customerId"],
        date: json["createdAt"],
        serviceAreaID: json["serviceAreaId"],
        customerSocketID: json["customerSocket"],
        otp: json["otp"] == null ? null : json["otp"],
        // otp: json["otp"],
      );
  // factory Order.waiting(Map<String, dynamic> json) => Order(
  //       price: json["price"],
  //       vehicleID: json["vehicleId"],
  //       pickup_lat: json["pickup"].values.elementAt(0).toString(),
  //       pickup_long: json["pickup"].values.elementAt(1).toString(),
  //       drop_lat: json["drop"].values.elementAt(0).toString(),
  //       drop_long: json["drop"].values.elementAt(1).toString(),
  //       status: json["status"],
  //       // driver_lat: json["subTrips"][0]["start"]["lat"].toString(),
  //       // driver_long: json["subTrips"][0]["start"]["long"].toString(),
  //       tripID: json["_id"],
  //       customerID: json["customerId"],
  //       date: json["createdAt"],
  //       serviceAreaID: json["serviceAreaId"],
  //       customerSocketID: json["customerSocket"],
  //       // otp: json["otp"],
  //     );
}
