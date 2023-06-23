import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/services/global_var.dart';
import 'package:voicepocket/models/login_model.dart';

Future<LoginModel> tokenRefreshPost() async {
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/reissue'
      : '$androidUrl/reissue';
  final pref = await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "accessToken": pref.getString("accessToken")!,
      "refreshToken": pref.getString("refreshToken")!,
    }),
  );
  //sleep(Duration(seconds: 10));
  if (response.statusCode == 200) {
    LoginModel loginModel = LoginModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (loginModel.success) {
      pref.setString("accessToken", loginModel.data!.accessToken);
      pref.setString("refreshToken", loginModel.data!.refreshToken);
    }
    return loginModel;
  } else if (response.statusCode > 400) {
    LoginModel loginModel = LoginModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );

    return loginModel;
  } else {
    throw Exception('Failed to post');
  }
}
