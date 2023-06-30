// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

class User {
  User(
      {
      this.address,
      this.role,
      this.userName,
      this.phoneNumber,
      this.id,
      this.v});

  String? address;
  String? role;
  String? userName;
  int? phoneNumber;
  String? id;
  int? v;

  factory User.fromMap(Map<String, dynamic> json) => User(
      address: json["address"],
      role: json["roleType"],
      userName: json["username"],
      phoneNumber: json["phoneNum"],
      id: json["_id"],
      v: json["__v"]);

  Map<String, dynamic> toMap() => {
        "address": address,
        "role": role,
        "userName": userName,
        "phoneNumber": phoneNumber,
        "_id": id,
        "__v": v,
      };
}
