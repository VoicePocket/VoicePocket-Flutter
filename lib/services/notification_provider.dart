import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/screens/voicepocket/media_player_screen.dart';
import 'package:voicepocket/services/google_cloud_service.dart';

import '../models/global_var.dart';

class NotificationProvider extends AsyncNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  //FCM 상태는 3가지(Back / Fore / Terminated)
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    //백그라운드에서 메시지를 받은 경우
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
  }

  Future<void> initListener() async {
    //android & ios permission
    final permission = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // apple background setting
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (permission.authorizationStatus == AuthorizationStatus.denied) return;

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'VoicePocketNotificationId', // id
      'VoicePocketNotificationName',
      description: 'VoicePocket FCM Test', // description
      importance: Importance.high,
    );
    //foreground 에서의 푸쉬 알람 표시를 위한 local notification 설정
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(
          "I got message in FOREGROUND\nMessage data: ${message.data['wavUrl']}");
      if (message.notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
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
      }
    });
    //Background
    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler);
    //Terminated
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      print(
          "I got message in TERMINATED\nMessage data: ${message.data['wavUrl']}");
    }
  }

  @override
  FutureOr build() async {
    String token = await _messaging.getToken() ?? "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (token == null) return;
    await initListener();
    _messaging.onTokenRefresh.listen((newToken) {
      token = newToken;
    });
    pref.setString("fcmKey", token);
    print(token);
  }
}

final notificationProvider = AsyncNotifierProvider(
  () => NotificationProvider(),
);
