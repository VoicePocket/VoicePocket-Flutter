import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/task_id_model.dart';

Future<TaskIdModel> requestTaskId() async {
  final pref = await SharedPreferences.getInstance();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/tts/status/uuid'
      : 'http://10.0.2.2:8080/api/tts/status/uuid';
  TaskIdModel model;
  final uuid2 = pref.getString("uuid");
  while (true) {
    await Future.delayed(const Duration(milliseconds: 500));

    final http.Response response = await http.get(
      Uri.parse('$uri/$uuid2'),
      headers: <String, String>{'X-AUTH-TOKEN': pref.getString("accessToken")!},
    );

    print('taskId 받아오는 중');
    if (response.statusCode == 200) {
      model = TaskIdModel.fromJson(
        json.decode(
          utf8.decode(response.bodyBytes),
        ),
      );
      break; // response가 성공적으로 올 경우 루프를 빠져나옴
    }
  }
  return model;
}

Future<int> taskStatus() async {
  final pref = await SharedPreferences.getInstance();
  TaskIdModel? taskidResponse;
  taskidResponse = await requestTaskId();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/tts/status/taskId'
      : 'http://10.0.2.2:8000/api/tts/status/taskId';
  String taskId = taskidResponse.data.taskId;
  final http.Response response = await http.get(
    Uri.parse('$uri/$taskId'),
    headers: <String, String>{
      //토큰 추가 (이메일, 패스워드 송신 필요)
      'X-AUTH-TOKEN': pref.getString("accessToken")!
    },
  );
  if (response.statusCode == 200) {
    print(response.statusCode);
    return response.statusCode;
  } else {
    print(response.statusCode);
    return response.statusCode;
  }
}
