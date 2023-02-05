import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/text_model.dart';

import 'device_info.dart';

void postText(String text) async {
  final String uuid = await getMobileId();

  final http.Response response = await http.post(
    Uri.parse('http://10.0.2.2:8000/api/texts/psg1478795@naver.com/make_wav'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'uuid': uuid,
      'text': text,
    }),
  );
  print(response.body);

  if (response.statusCode == 201) {
    TextModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to post');
  }
}
