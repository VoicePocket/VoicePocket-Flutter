class FriendShipRequestModel {
  bool success;
  int code;
  String message;
  List<Data> data;

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
      data: (json['data']! as List).map((e) => Data.fromDynamic(e)).toList(),
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

  factory Data.fromDynamic(Map<String, dynamic> json1) {
    return Data(
      id: json1['id'],
      requestFrom: RequestFrom.fromDynamic(json1['request_from']),
      requestTo: RequestTo.fromDynamic(json1['request_to']),
      status: json1['status'],
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

  factory RequestFrom.fromDynamic(Map<String, dynamic> json) {
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

  factory RequestTo.fromDynamic(Map<String, dynamic> json) {
    return RequestTo(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      nickName: json['nickName'],
    );
  }
}
