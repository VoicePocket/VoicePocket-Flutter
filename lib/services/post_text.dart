import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/services/global_var.dart';
import 'package:voicepocket/models/text_model.dart';

Future<TextModel> postText(String text) async {
  final pref = await SharedPreferences.getInstance();
  final uuid = const Uuid().v1();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/tts/send'
      : '$androidUrl/tts/send';
  await pref.setString("uuid", uuid);
  int count = 0;

  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN': pref.getString("accessToken")!,
    },
    body: jsonEncode(<String, String>{
      "type": "ETL",
      "uuid": uuid,
      "requestTo": pref.getString("email")!,
      "text": text
    }),
  );
  if (response.statusCode == 200) {
    TextModel model = TextModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (model.success) {
      print(model.message);
    }
    return model;
  } else {
    TextModel model = TextModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    Fluttertoast.showToast(
      msg: model.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    return model;
  }
}

Future<TextModel> postTextDemo(String text, String email) async {
  final pref = await SharedPreferences.getInstance();
  final uuid = const Uuid().v1();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;

  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/tts/send'
      : '$androidUrl/tts/send';

  await pref.setString("uuid", uuid);
  int count = 0;

  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      //토큰 추가 (이메일, 패스워드 송신 필요)
      'Content-Type': 'application/json; charset=UTF-8',
      'X-AUTH-TOKEN': pref.getString("accessToken")!,
    },
    body: jsonEncode(<String, String>{
      "type": "ETL",
      "uuid": uuid,
      "requestTo": email,
      "text": text
    }),
  );
  // while (await taskStatus() != 200) {
  //   // 2초 동안 기다립니다.
  //   print('post text창 $taskStatus');
  //   print("response 없는 상태, 2초 딜레이 $count");
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   // 다시 요청합니다.
  //   //taskStatus;
  //   count += 1;
  //   if (count == 30) {
  //     throw Exception('Failed to post');
  //   }
  // }

  if (response.statusCode == 200) {
    TextModel model = TextModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    print(model.message);
    return model;
  } else {
    throw Exception('Failed to post');
  }
}
