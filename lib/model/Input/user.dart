class User {
  String? sId;
  String? username;
  String? password;
  String? roleType;
  int? phoneNum;
  String? address;
  bool? isVerified;
  bool? isActive;
  int? iV;
  String? roleId;

  User(
      {this.sId,
      this.username,
      this.password,
      this.roleType,
      this.phoneNum,
      this.address,
      this.isVerified,
      this.isActive,
      this.iV,
      this.roleId});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    password = json['password'];
    roleType = json['roleType'];
    phoneNum = json['phoneNum'];
    address = json['address'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    iV = json['__v'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['username'] = username;
    data['password'] = password;
    data['roleType'] = roleType;
    data['phoneNum'] = phoneNum;
    data['address'] = address;
    data['isVerified'] = isVerified;
    data['isActive'] = isActive;
    data['__v'] = iV;
    data['roleId'] = roleId;
    return data;
  }
}
