class FriendShipModel {
  bool success;
  int code;
  String message;
  Data? data;

  FriendShipModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory FriendShipModel.fromJson(Map<String, dynamic> json) {
    return FriendShipModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: json['success'] ? json['data'] : null,
    );
  }
}

class Data {
  int id;
  RequestFrom requestFrom;
  RequestTo requestTo;
  String status;

  Data({
    required this.id,
    required this.requestFrom,
    required this.requestTo,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      requestFrom: json['requestFrom'],
      requestTo: json['requestTo'],
      status: json['status'],
    );
  }
}

class RequestFrom {
  int userId;
  String email;
  String name;
  String nickName;

  RequestFrom({
    required this.userId,
    required this.email,
    required this.name,
    required this.nickName,
  });

  factory RequestFrom.fromJson(Map<String, dynamic> json) {
    return RequestFrom(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      nickName: json['nickName'],
    );
  }
}

class RequestTo {
  int userId;
  String email;
  String name;
  String nickName;

  RequestTo({
    required this.userId,
    required this.email,
    required this.name,
    required this.nickName,
  });

  factory RequestTo.fromJson(Map<String, dynamic> json) {
    return RequestTo(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      nickName: json['nickName'],
    );
  }
}
