class FriendShipRequestModel {
  bool success;
  int code;
  String message;
  DataR? data;

  FriendShipRequestModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory FriendShipRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendShipRequestModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: json['success'] ? DataR.fromJson(json['data']) : null,
    );
  }
}

class DataR {
  int id;
  RequestFrom requestFrom;
  RequestTo requestTo;
  String status;

  DataR({
    required this.id,
    required this.requestFrom,
    required this.requestTo,
    required this.status,
  });

  factory DataR.fromJson(Map<String, dynamic> json) {
    return DataR(
      id: json['id'],
      requestFrom: RequestFrom.fromJson(json['request_from']),
      requestTo: RequestTo.fromJson(json['request_to']),
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
