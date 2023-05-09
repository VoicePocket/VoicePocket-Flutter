class TaskIdModel {
  bool success;
  int code;
  String message;
  Data data;

  TaskIdModel(
      {required this.success,
      required this.code,
      required this.message,
      required this.data});

  factory TaskIdModel.fromJson(Map<String, dynamic> json) {
    return TaskIdModel(
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
