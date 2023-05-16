import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/login_model.dart';
import 'package:voicepocket/services/get_user_info.dart';

Future<LoginModel> loginPost(String email, String password) async {
  final pref = await SharedPreferences.getInstance();
  await pref.clear();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/login'
      : 'http://10.0.2.2:8000/api/login';
  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "password": password,
    }),
  );
  if (response.statusCode == 200) {
    LoginModel loginModel = LoginModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    if (loginModel.success) {
      pref.setString("accessToken", loginModel.data!.accessToken);
      pref.setString("refreshToken", loginModel.data!.refreshToken);
      await requestUserInfo(email);
    }
    return loginModel;
  } else {
    LoginModel loginModel = LoginModel.fromJson(
      json.decode(
        utf8.decode(response.bodyBytes),
      ),
    );
    Fluttertoast.showToast(
      msg: loginModel.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    return loginModel;
  }
}