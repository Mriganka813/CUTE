class Vehicle {
  Vehicle(
      {this.price,
      this.vehicleType,
      this.vehicleId,
      this.pricePerKM,
      this.distance,
      this.serviceAreaID});

  double? price;
  int? pricePerKM;
  String? vehicleType;
  String? vehicleId;
  double? distance;
  String? serviceAreaID;

  factory Vehicle.fromMap(Map<String, dynamic> json) => Vehicle(
      price: double.parse(json["price"].toString()),
      pricePerKM: json["pricePerKm"],
      vehicleType: json["name"],
      vehicleId: json["id"],
      serviceAreaID: json["ServiceAreaId"]);

  // factory Vehicle.distance(Map<String, dynamic> json) =>
  //     Vehicle(distance: json.values.elementAt(0));
}
