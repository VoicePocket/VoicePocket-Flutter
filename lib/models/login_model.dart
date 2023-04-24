class LoginModel {
  bool success;
  int code;
  String message;
  Data? data;

  LoginModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: json['success'] ? Data.fromJson(json["data"]) : null,
    );
  }
}

class Data {
  String grantType;
  String accessToken;
  String refreshToken;
  int accessTokenExpireDate;

  Data({
    required this.grantType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpireDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      grantType: json['grantType'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      accessTokenExpireDate: json['accessTokenExpireDate'],
    );
  }
}
