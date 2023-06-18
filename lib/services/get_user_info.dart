import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/user_info_model.dart';
import 'package:voicepocket/services/global_var.dart';

Future<UserInfoModel> getUserInfo(String email) async {
  final pref = await SharedPreferences.getInstance();
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/user/email/${email.split('@')[0]}%40${email.split('@')[1]}?lang=ko'
      : '$androidUrl/user/email/${email.split('@')[0]}%40${email.split('@')[1]}?lang=ko';
  UserInfoModel model;
  final http.Response response = await http.get(
    Uri.parse(uri),
    headers: <String, String>{'X-AUTH-TOKEN': pref.getString("accessToken")!},
  );
  if (response.statusCode == 200) {
    model = UserInfoModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (model.success) {
      pref.setString("nickname", model.data.nickName);
      pref.setString("name", model.data.name);
    }
    return model;
  } else {
    model = UserInfoModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );

    return model;
  }
}
