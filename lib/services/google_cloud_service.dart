import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AutoRefreshingAuthClient> getAuthClient() async {
  final jsonCredentials = await rootBundle
      .loadString('assets/credentials/voicepocket-bucketKey.json');
  final credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
  final client =
      await auth.clientViaServiceAccount(credentials, Storage.SCOPES);
  return client;
}

// Future<void> readWavFileFromBucket(TextModel response, String uuid) async {
//   // wav파일 bucket에서 받아오는 함수
//   final client = await getAuthClient();
//   final directory = await getApplicationDocumentsDirectory();
//   try {
//     final storage = Storage(client, "VoicePocket");
//     final bucket = storage.bucket("voicepocket");
//     await bucket.read("${response.data.email}/${response.data.uuid}.wav").pipe(
//           File("${directory.path}/wav/${response.data.email}/${response.data.uuid}.wav")
//               .openWrite(),
//         );
//     print(
//         "wav파일 받아온 저장 경로: ${directory.path}/wav/${response.data.email}/${response.data.uuid}.wav");
//   } finally {
//     client.close();
//   }
// }

Future<void> readWavFileFromNotification(String wavUrl) async {
  // wav파일 bucket에서 받아오는 함수
  final client = await getAuthClient();
  final directory = await getPublicDownloadFolderPath();
  try {
    final storage = Storage(client, "VoicePocket");
    final bucket = storage.bucket("voice_pocket_egg");

    await bucket.read(wavUrl).pipe(
          File("${directory.path}/wav/$wavUrl").openWrite(),
        );
    print("wav파일 받아온 저장 경로: ${directory.path}/wav/$wavUrl");
  } on FirebaseException catch (e) {
    // Caught an exception from Firebase.
    print("Failed with error '${e.code}': ${e.message}");
  } finally {
    client.close();
  }
}

Future<void> readAllWavFiles(String email) async {
  // wav파일 bucket에서 받아오는 함수
  final client = await getAuthClient();
  final directory = await getApplicationDocumentsDirectory();
  try {
    final storage = Storage(client, "VoicePocket");
    final bucket = storage.bucket("voice_pocket_egg");

    final wavlist = bucket.list(
      prefix: "$email/",
    );
    await for (var wav in wavlist) {
      if (wav.name.endsWith(".wav") &&
          !(await File("${directory.path}/model/${wav.name.split("/")[1]}")
              .exists())) {
        await bucket.read(wav.name).pipe(
              File("${directory.path}/model/${wav.name.split("/")[1]}")
                  .openWrite(),
            );
        print(wav.name);
      }
    }
    print("받아오기 완료");
  } finally {
    client.close();
  }
}

Future<bool> uploadModelVoiceFileToBucket() async {
  // 모델 생성을 위한 녹음파일 버킷에 업로드
  final pref = await SharedPreferences.getInstance();
  final email = pref.getString("email");
  final client = await getAuthClient();
  final directory = await getApplicationDocumentsDirectory();
  try {
    final storage = Storage(client, "VoicePocket");
    final bucket = storage.bucket("voice_pocket_egg");

    await File("${directory.path}/$email.zip") // 로컬의 파일명
        .openRead()
        .pipe(bucket.write("$email/$email.zip")); // 버킷 내에 경로 및  파일명
    print("버킷 업로드 완료");
  } catch (e) {
    return false;
  } finally {
    File("${directory.path}/$email.zip").delete();
    client.close();
  }
  return true;
}

Future<Directory> getPublicDownloadFolderPath() async {
  String? downloadDirPath;

  // 만약 다운로드 폴더가 존재하지 않는다면 앱내 파일 패스를 대신 주도록한다.
  if (Platform.isAndroid) {
    downloadDirPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    Directory dir = Directory(downloadDirPath);

    if (!dir.existsSync()) {
      downloadDirPath = (await getExternalStorageDirectory())!.path;
    }
  } else if (Platform.isIOS) {
    // downloadDirPath = (await getApplicationSupportDirectory())!.path;
    downloadDirPath = (await getApplicationDocumentsDirectory()).path;
  }
  return Directory(downloadDirPath!);
}
