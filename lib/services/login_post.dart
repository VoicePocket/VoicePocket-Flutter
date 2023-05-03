import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/login_model.dart';

Future<LoginModel> loginPost(String email, String password) async {
  final pref = await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    Uri.parse('http://localhost:8080/api/login'), // IOS
    //'http://172.20.10.12:8080/send'), // Real-test
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "password": password,
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
      pref.setString("email", email);
      pref.setString("accessToken", loginModel.data!.accessToken);
      pref.setString("refreshToken", loginModel.data!.refreshToken);
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
