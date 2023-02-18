import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:path_provider/path_provider.dart';
import 'package:voicepocket/models/text_model.dart';

Future<void> obtainCredentials(TextModel response, String uuid) async {
  var jsonCredentials = await rootBundle
      .loadString('assets/credentials/voicepocket-bucketKey.json');
  var credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
  var scopes = Storage.SCOPES;

  var client = await auth.clientViaServiceAccount(credentials, scopes);

  try {
    var storage = Storage(client, "VoicePocket");
    var bucket = storage.bucket("voice_pocket");

    var directory = await getApplicationDocumentsDirectory();

    await bucket
        .read(response.wavUrl)
        .pipe(File("${directory.path}/$uuid.wav").openWrite());

    await File('${directory.path}/my-file.txt')
        .openRead()
        .pipe(bucket.write('response.wavUrl'));
    print(directory.path);
    print(storage);
  } finally {
    client.close();
  }
}
