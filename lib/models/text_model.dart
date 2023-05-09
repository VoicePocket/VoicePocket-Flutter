class TextModel {
  bool success;
  int code;
  String message;
  Data data;

  TextModel(
      {required this.success,
      required this.code,
      required this.message,
      required this.data});

  factory TextModel.fromJson(Map<String, dynamic> json) {
    return TextModel(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String type;
  String uuid;
  String email;
  String text;

  Data({
    required this.type,
    required this.uuid,
    required this.email,
    required this.text,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      type: json['type'],
      uuid: json['uuid'],
      email: json['email'],
      text: json['text'],
    );
  }
}
