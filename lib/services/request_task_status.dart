import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/models/task_id_model.dart';
import 'package:voicepocket/services/request_task_id.dart';

Future<int> taskStatus() async {
  final pref = await SharedPreferences.getInstance();
  TextModel2? taskidResponse;
  taskidResponse = await requestTaskId();
  var taskId = taskidResponse.data.taskId;
  final http.Response response = await http.get(
    Uri.parse('http://localhost:8080/api/tts/status/taskId/$taskId'), // IOS
    //'http://172.20.10.12:8080/api/tts/status/uuid/'), // Real-test
    //Uri.parse('http://10.0.0.2:8000/api/texts/psg1478795@naver.com/make_wav'), // ANDROID
    headers: <String, String>{
      //토큰 추가 (이메일, 패스워드 송신 필요)
      'X-AUTH-TOKEN': pref.getString("accessToken")!
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
