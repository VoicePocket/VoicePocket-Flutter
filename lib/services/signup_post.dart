import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/signup_model.dart';

Future<SignUpModel> signUpPost(
    String email, String password, String name, String nickName) async {
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/signup'
      : 'http://10.0.2.2:8080/api/signup';
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
