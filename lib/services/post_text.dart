import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/google_cloud_service.dart';

Future<TextModel> postText(String text) async {
  var uuid = const Uuid().v1();
  final http.Response response = await http.post(
    Uri.parse(
        'http://localhost:8080/send'), // IOS
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
    "type": "ETL",
    "uuid": uuid,
    "email": "wnsgur735@naver.com",
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