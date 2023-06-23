class TextModel {
  bool success;
  int code;
  String message;

  TextModel({
    required this.success,
    required this.code,
    required this.message,
  });

  factory TextModel.fromJson(Map<String, dynamic> json) {
    return TextModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
    );
  }
}
