class FriendShipRequestGetModel {
  bool success;
  int code;
  String message;
  List<DataG> data;

  FriendShipRequestGetModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory FriendShipRequestGetModel.fromJson(Map<String, dynamic> json) {
    return FriendShipRequestGetModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: (json['data']! as List).map((e) => DataG.fromDynamic(e)).toList(),
    );
  }
}

class DataG {
  int id;
  RequestFrom requestFrom;
  RequestTo requestTo;
  String status;

  DataG({
    required this.id,
    required this.requestFrom,
    required this.requestTo,
    required this.status,
  });

  factory DataG.fromDynamic(Map<String, dynamic> json1) {
    return DataG(
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
