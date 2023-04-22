import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/taskid_model.dart';
import 'package:voicepocket/services/post_text.dart';

int count = 0;

Future<TextModel2> requestTaskId() async {
  TextModel2 model;
  var uuid2 = request_uuid;
  print(uuid2);
  
  while (true) {
    await Future.delayed(const Duration(seconds: 2));
    
    final http.Response response = await http.get(
      Uri.parse(
          'http://localhost:8080/api/tts/status/uuid/$uuid2'),
      headers: <String, String>{
        'X-AUTH-TOKEN':'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTY4MjE1MDkwNSwiZXhwIjoxNjgyMTU0NTA1fQ.J7BFIjegn3uZIWGWOgR-tX0Oie_afF3z28vCQH7H_lU',
      },
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