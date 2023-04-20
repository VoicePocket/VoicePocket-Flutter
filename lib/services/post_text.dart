import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/google_cloud_service.dart';

Future<TextModel> postText(String text) async {
  var uuid = const Uuid().v1();
  final http.Response response = await http.post(
    Uri.parse('http://localhost:8080/send'), // IOS
    //'http://172.20.10.12:8080/send'), // Real-test
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      //토큰 추가 (이메일, 패스워드 송신 필요)
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTY4MTkyNTI3MCwiZXhwIjoxNjgxOTI4ODcwfQ.VOVTQ477Xa_Ys8Ja_M6__rNsmzJb5dSgGkFWkE-m9cw',
    },
    body: jsonEncode(<String, String>{
      "type": "ETL",
      "uuid": uuid,
      "email": "ljgsample@naver.com",
      "text": text
    }),
  );
  //sleep(Duration(seconds: 10));
  if (response.statusCode == 200) {
    TextModel model = TextModel.fromJson(json.decode(response.body));
    print(model.data.wavUrl);
    await readWavFileFromBucket(model, uuid);
    return model;
  } else {
    throw Exception('Failed to post');
  }
}
