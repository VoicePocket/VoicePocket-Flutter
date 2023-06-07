import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/login_model.dart';

import 'dart:io'; //Platform 사용을 위한 패키지
import 'package:flutter/services.dart'; //PlatformException 사용을 위한 패키지
import 'package:device_info/device_info.dart'; // 디바이스 정보 사용 패키지

Future<String> getMobileId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String id = '';
  try {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidData = await deviceInfoPlugin.androidInfo;
      id = androidData.androidId;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosData = await deviceInfoPlugin.iosInfo;
      id = iosData.identifierForVendor;
    }
  } on PlatformException {
    id = '';
  }
  return id;
}

Future<LoginModel> loginPost(
    String email, String password, String fcmToken) async {
  final pref = await SharedPreferences.getInstance();
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? 'http://localhost:8080/api/login'
      : 'http://10.0.2.2:8080/api/login';
  final String mobileId = await getMobileId();
  final http.Response response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'FCM-TOKEN': fcmToken,
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
      print("id = $mobileId");
      print(loginModel.data!.accessToken);
      pref.setString("accessToken", loginModel.data!.accessToken);
      pref.setString("refreshToken", loginModel.data!.refreshToken);
      //await requestUserInfo(email);
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