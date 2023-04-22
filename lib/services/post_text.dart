import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/google_cloud_service.dart';

Future<TextModel> postText(String text) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final uuid = const Uuid().v1();

  final http.Response response = await http.post(
    Uri.parse('http://localhost:8080/send'), // IOS
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
  sleep(const Duration(seconds: 20));
  if (response.statusCode == 200) {
    TextModel model = TextModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    print(model.data.wavUrl);
    await readWavFileFromBucket(model, uuid);
    return model;
  } else {
    throw Exception('Failed to post');
  }
}
