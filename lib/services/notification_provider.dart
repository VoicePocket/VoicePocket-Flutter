import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';

class NotificationProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initListener(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) return;
    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "I got message in FOREGROUND\nMessage data: ${message.notification?.title}");
    });
    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "I got message in BACKGROUND\nMessage data: ${message.notification?.title}");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
    //Terminated
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      print(
          "I got message in TERMINATED\nMessage data: ${message.notification?.title}");
    }
  }

  @override
  FutureOr build(BuildContext context) async {
    String? token = await _messaging.getToken();
    if (token == null) return;
    await initListener(context);
    _messaging.onTokenRefresh.listen((newToken) {
      token = newToken;
    });
    print(token);
  }
}

final notificationProvider = AsyncNotifierProvider.family(
  () => NotificationProvider(),
);
