import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voicepocket/screens/voicepocket/media_player_screen.dart';
import 'package:voicepocket/services/google_cloud_service.dart';

import '../models/global_var.dart';

class NotificationProvider extends AsyncNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initListener() async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) return;
    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          "I got message in FOREGROUND\nMessage data: ${message.data['wavUrl']}");
      final wavUrl = message.data['wavUrl'];
      await readWavFileFromNotification(wavUrl);
      if (message.data['wavUrl'].endsWith('.wav')) {
        Navigator.of(GlobalVariable.navState.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => MediaPlayerScreen(
              email: wavUrl.split("/")[0],
              path: wavUrl.split("/")[1],
            ),
          ),
        );
        return;
      }
    });
    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          "I got message in BACKGROUND\nMessage data: ${message.data['wavUrl']}");
      final wavUrl = message.data['wavUrl'];
      await readWavFileFromNotification(wavUrl);
      if (message.data['wavUrl'].endsWith('.wav')) {
        Navigator.of(GlobalVariable.navState.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => MediaPlayerScreen(
              email: wavUrl.split("/")[0],
              path: wavUrl.split("/")[1],
            ),
          ),
        );
        return;
      }
    });
    //Terminated
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      print(
          "I got message in TERMINATED\nMessage data: ${message.data['wavUrl']}");
    }
  }

  @override
  FutureOr build() async {
    String? token = await _messaging.getToken();
    if (token == null) return;
    await initListener();
    _messaging.onTokenRefresh.listen((newToken) {
      token = newToken;
    });
    print(token);
  }
}

final notificationProvider = AsyncNotifierProvider(
  () => NotificationProvider(),
);
