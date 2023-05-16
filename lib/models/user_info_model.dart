class UserInfoModel {
  bool success;
  int code;
  String message;
  Data data;

  UserInfoModel(
      {required this.success,
      required this.code,
      required this.message,
      required this.data});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  int userId;
  String email, name, nickName;

  Data({
    required this.userId,
    required this.email,
    required this.name,
    required this.nickName,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      nickName: json['nickName'],
    );
  }
}
