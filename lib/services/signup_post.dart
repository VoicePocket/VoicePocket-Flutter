import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/services/global_var.dart';
import 'package:voicepocket/models/signup_model.dart';

Future<SignUpModel> signUpPost(
    String email, String password, String name, String nickName) async {
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/signup'
      : '$androidUrl/signup';
  final http.Response response = await http.post(
    Uri.parse(uri), // IOS
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "password": password,
      "name": name,
      "nickName": nickName
    }),
  );
  //sleep(Duration(seconds: 10));
  if (response.statusCode == 200) {
    SignUpModel signUpModel = SignUpModel.fromJson(
      json.decode(utf8.decode(response.bodyBytes)),
    );
    return signUpModel;
  } else {
    SignUpModel signUpModel = SignUpModel.fromJson(
      json.decode(utf8.decode(response.bodyBytes)),
    );
    Fluttertoast.showToast(
      msg: signUpModel.message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    return signUpModel;
  }
}
