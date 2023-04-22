class TextModel {
  bool success;
  int code;
  String message;
  Data data;

  TextModel({required this.success, required this.code, required this.message, required this.data});

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
  String uuid;
  String taskId;
  String result;

  Data({required this.uuid, required this.taskId, required this.result});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      uuid: json['uuid'],
      taskId: json['taskId'],
      result: json['result']
    );
  }
}