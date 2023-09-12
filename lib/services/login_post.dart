import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/services/global_var.dart';
import 'package:voicepocket/models/login_model.dart';

import 'dart:io'; //Platform 사용을 위한 패키지
import 'package:flutter/services.dart'; //PlatformException 사용을 위한 패키지
import 'package:device_info/device_info.dart';

import 'google_cloud_service.dart'; // 디바이스 정보 사용 패키지

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

Future<void> createFolder(String email) async {
  final routeDir = await getPublicDownloadFolderPath();
  print("default 저장 경로: ${routeDir.path}");
  final modelDir = Directory('${routeDir.path}/model');
  final wavHomeDir = Directory('${routeDir.path}/wav');
  final wavDir = Directory('${routeDir.path}/wav/$email');
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if (!(await modelDir.exists())) {
    await modelDir.create();
  }
  if (!(await wavHomeDir.exists())) {
    await wavHomeDir.create();
  }
  if (!(await wavDir.exists())) {
    await wavDir.create();
  }
}

Future<LoginModel> loginPost(String email, String password) async {
  final pref = await SharedPreferences.getInstance();
  final fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
  print("전송전: $fcmToken");
  const String iosUrl = VoicePocketUri.iosUrl;
  const String androidUrl = VoicePocketUri.androidUrl;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? '$iosUrl/login'
      : '$androidUrl/login';
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
      print("Access: ${loginModel.data!.accessToken}");
      print('Refresh: ${loginModel.data!.refreshToken}');
      await createFolder(email);
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
    // Fluttertoast.showToast(
    //   msg: loginModel.message,
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   textColor: Colors.white,
    //   backgroundColor: const Color(0xFFA594F9),
    //   fontSize: Sizes.size16,
    // );
    return loginModel;
  }
}
