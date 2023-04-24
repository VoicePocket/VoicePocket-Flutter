import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/login_model.dart';

Future<LoginModel> tokenRefreshPost() async {
  final pref = await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    Uri.parse('http://localhost:8080/api/reissue'), // IOS
    //'http://172.20.10.12:8080/api/reissue'), // Real-test
    //Uri.parse('http://10.0.0.2:8000//api/reissue'), // ANDROID
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
    pref.setString("accessToken", loginModel.data!.accessToken);
    pref.setString("refreshToken", loginModel.data!.refreshToken);
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
