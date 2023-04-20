import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/login_model.dart';

Future<LoginModel> loginPost(String email, String password) async {
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
