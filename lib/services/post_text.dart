import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/bucket_to_local.dart';

Future<TextModel> postText(String text) async {
  var uuid = const Uuid().v1();
  final http.Response response = await http.post(
    Uri.parse(
        'http://localhost:8000/api/texts/psg1478795@naver.com/make_wav'), // IOS
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'uuid': uuid,
      'text': text,
    }),
  );
  if (response.statusCode == 201) {
    TextModel model = TextModel.fromJson(json.decode(response.body));
    print(model.wavUrl);
    await obtainCredentials(model, uuid);
    return model;
  } else {
    throw Exception('Failed to post');
  }
}
