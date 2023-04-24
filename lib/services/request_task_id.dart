import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/task_id_model.dart';

int count = 0;

Future<TextModel2> requestTaskId() async {
  final pref = await SharedPreferences.getInstance();
  TextModel2 model;
  final uuid2 = pref.getString("uuid");
  print(uuid2);

  while (true) {
    await Future.delayed(const Duration(seconds: 2));

    final http.Response response = await http.get(
      Uri.parse('http://localhost:8080/api/tts/status/uuid/$uuid2'),
      headers: <String, String>{'X-AUTH-TOKEN': pref.getString("accessToken")!},
    );

    print('taskId 받아오는 중');
    print(response.statusCode);

    if (response.statusCode == 200) {
      model = TextModel2.fromJson(json.decode(response.body));
      print(model.data.taskId);
      break; // response가 성공적으로 올 경우 루프를 빠져나옴
    }
  }

  return model;
}
