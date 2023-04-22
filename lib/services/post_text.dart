import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/google_cloud_service.dart';
import 'package:voicepocket/services/request_task_status.dart';

var request_uuid = '';

Future<TextModel> postText(String text) async {
  var uuid = const Uuid().v1();
  request_uuid = uuid;
  print('uuid $uuid');
  int count = 0;
  final http.Response response = await http.post(
    Uri.parse(
        'http://localhost:8080/api/tts/send'), // IOS
        //'http://172.20.10.12:8080/api/tts/send'), // Real-test
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      //토큰 추가 (이메일, 패스워드 송신 필요)
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN':'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTY4MjE1MDkwNSwiZXhwIjoxNjgyMTU0NTA1fQ.J7BFIjegn3uZIWGWOgR-tX0Oie_afF3z28vCQH7H_lU',
    },
    body: jsonEncode(<String, String>{
    "type": "ETL",
    "uuid": uuid,
    "email": "ljgsample@naver.com",
    "text": text
    }),
  );
  while (await taskStatus() != 200) {
    // 2초 동안 기다립니다.
    print('post text창 $taskStatus');
    print("response 없는 상태, 2초 딜레이 $count");
    await Future.delayed(const Duration(seconds: 2));
    // 다시 요청합니다.
    //taskStatus;
    count += 1;
    if (count == 15){
      throw Exception('Failed to post');
    }
  }

  if (response.statusCode == 200) {
    TextModel model = TextModel.fromJson(json.decode(response.body));
    print(model.data.wavUrl);

    await readWavFileFromBucket(model, uuid);
    return model;
  } else {
    throw Exception('Failed to post');
  }
}