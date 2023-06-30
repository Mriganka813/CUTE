class NewTripInput {
  NewTripInput({
    this.price,
    this.vehicleId,
    this.serviceAreaId,
    this.pickuplocation,
    this.droplocatioon,
  });

  double? price;
  String? serviceAreaId;
  String? vehicleId;
  var pickuplocation;
  var droplocatioon;

  Map<String, dynamic> toMap() => {
        "pickup": {"lat": decodelocation(pickuplocation, 0).toString(), "long": decodelocation(pickuplocation, 1).toString()},
        "drop": {"lat": decodelocation(droplocatioon, 0).toString(), "long": decodelocation(droplocatioon, 1).toString()},
        "serviceAreaId": serviceAreaId,
        "vehicleId": vehicleId,
        "price": price
      };

  // index 0 = lat, index 1 = long
  decodelocation(location, int index) {
    Map<String, dynamic> loc = location;
    return loc.values.elementAt(index);
  }
}
