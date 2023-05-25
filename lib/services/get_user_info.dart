import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/user_info_model.dart';

Future<UserInfoModel> requestUserInfo(String email) async {
  final pref = await SharedPreferences.getInstance();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/user/email/${email.split('@')[0]}%40${email.split('@')[1]}?lang=ko'
      : 'http://10.0.2.2:8080/api/user/email/${email.split('@')[0]}%40${email.split('@')[1]}?lang=ko';
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
      pref.setString("email", model.data.email);
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
