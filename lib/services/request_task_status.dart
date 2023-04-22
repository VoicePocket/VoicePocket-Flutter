import 'package:http/http.dart' as http;
import 'package:voicepocket/models/taskid_model.dart';
import 'package:voicepocket/services/request_taskid.dart';

Future<int> taskStatus() async {
  TextModel2? taskidResponse;
  taskidResponse = await requestTaskId();
  var taskId = taskidResponse.data.taskId;
  final http.Response response = await http.get(
    Uri.parse(
        'http://localhost:8080/api/tts/status/taskId/$taskId'), // IOS
        //'http://172.20.10.12:8080/api/tts/status/uuid/'), // Real-test
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      //토큰 추가 (이메일, 패스워드 송신 필요)
      'X-AUTH-TOKEN':'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTY4MjE1MDkwNSwiZXhwIjoxNjgyMTU0NTA1fQ.J7BFIjegn3uZIWGWOgR-tX0Oie_afF3z28vCQH7H_lU',
    },
  );
  print(taskId);

  if (response.statusCode == 200) {
    print(response.statusCode);
    return response.statusCode;
  } else {
    print(response.statusCode);
    return response.statusCode;
  }
}