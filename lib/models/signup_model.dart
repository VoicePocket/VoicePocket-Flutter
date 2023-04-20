class SignUpModel {
  bool success;
  int code;
  String message;

  SignUpModel({
    required this.success,
    required this.code,
    required this.message,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
    );
  }
}
