import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voicepocket/models/text_model.dart';

Future<AutoRefreshingAuthClient> getAuthClient() async {
  final jsonCredentials = await rootBundle
      .loadString('assets/credentials/voicepocket-bucketKey.json');
  final credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
  final client =
      await auth.clientViaServiceAccount(credentials, Storage.SCOPES);
  return client;
}

Future<void> readWavFileFromBucket(TextModel response, String uuid) async {
  // wav파일 bucket에서 받아오는 함수
  final client = await getAuthClient();
  final directory = await getApplicationDocumentsDirectory();
  try {
    final storage = Storage(client, "VoicePocket");
    final bucket = storage.bucket("voice_pocket");

    await bucket.read(response.wavUrl).pipe(
          File("${directory.path}/${response.wavUrl.split("/")[1]}")
              .openWrite(),
        );

    print("${directory.path}/${response.wavUrl.split("/")[1]}");
  } finally {
    client.close();
  }
}

Future<void> uploadModelVoiceFileToBucket() async {
  // 모델 생성을 위한 녹음파일 버킷에 업로드
  final client = await getAuthClient();
  final directory = await getApplicationDocumentsDirectory();
  try {
    final storage = Storage(client, "VoicePocket");
    final bucket = storage.bucket("voice_pocket");

    await File("${directory.path}/psg1478795@naver.com.zip") // 로컬의 파일명
        .openRead()
        .pipe(bucket.write(
            "psg1478795@naver.com/psg1478795@naver.com.zip")); // 버킷 내에 경로 및  파일명
    print("upload complete");
  } finally {
    File("${directory.path}/psg1478795@naver.com.zip").delete();
    client.close();
  }
}