import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voicepocket/models/signup_model.dart';

Future<SignUpModel> signUpPost(
    String email, String password, String name, String nickName) async {
  final http.Response response = await http.post(
    Uri.parse('http://localhost:8080/api/signup'), // IOS
    //'http://172.20.10.12:8080/send'), // Real-test
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
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
    print(signUpModel.code);
    return signUpModel;
  } else if (response.statusCode == 400) {
    SignUpModel signUpModel = SignUpModel.fromJson(
      json.decode(utf8.decode(response.bodyBytes)),
    );
    print(signUpModel.code);
    return signUpModel;
  } else {
    throw Exception('Failed to post');
  }
}
