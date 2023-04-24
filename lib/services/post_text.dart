import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/google_cloud_service.dart';
import 'package:voicepocket/services/request_task_status.dart';

Future<TextModel> postText(String text) async {
  final pref = await SharedPreferences.getInstance();
  final uuid = const Uuid().v1();
  await pref.setString("uuid", uuid);
  int count = 0;

  final http.Response response = await http.post(
    Uri.parse('http://localhost:8080/api/tts/send'), // IOS
    //'http://172.20.10.12:8080/send'), // Real-test
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      //토큰 추가 (이메일, 패스워드 송신 필요)
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN': pref.getString("accessToken")!,
    },
    body: jsonEncode(<String, String>{
      "type": "ETL",
      "uuid": uuid,
      "email": pref.getString("email")!,
      "text": text
    }),
  );
  while (await taskStatus() != 200) {
    // 2초 동안 기다립니다.
    print('post text창 $taskStatus');
    print("response 없는 상태, 2초 딜레이 $count");
    await Future.delayed(const Duration(milliseconds: 500));
    // 다시 요청합니다.
    //taskStatus;
    count += 1;
    if (count == 15) {
      throw Exception('Failed to post');
    }
  }

  if (response.statusCode == 200) {
    TextModel model = TextModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    await readWavFileFromBucket(model, uuid);
    print("다운로드 완료");
    return model;
  } else {
    throw Exception('Failed to post');
  }
}
