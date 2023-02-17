import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/text_model.dart';

Future<TextModel> postText(String text, String uuid) async {
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
    return model;
  } else {
    throw Exception('Failed to post');
  }
}
