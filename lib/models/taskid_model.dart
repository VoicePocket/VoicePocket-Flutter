class TextModel2 {
  bool success;
  int code;
  String message;
  Data data;

  TextModel2({required this.success, required this.code, required this.message, required this.data});

  factory TextModel2.fromJson(Map<String, dynamic> json) {
    return TextModel2(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String uuid;
  String taskId;

  Data({required this.uuid, required this.taskId});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      uuid: json['uuid'],
      taskId: json['taskId'],
    );
  }
}