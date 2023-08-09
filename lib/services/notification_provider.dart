import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicepocket/screens/friend/friend_main_screen.dart';

import 'global_var.dart';

class NotificationProvider extends AsyncNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String defaultEmail = "";
  //FCM 상태는 3가지(Back / Fore / Terminated)
  Future<void> initListener() async {
    print('noti init');
    //android & ios permission
    final permission = await Permission.notification.request();
    if (permission.isLimited ||
        permission.isDenied ||
        permission.isPermanentlyDenied) {
      await openAppSettings();
    }
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'VoicePocketNotificationId', // id
      'VoicePocketNotificationName1',
      description: 'VoicePocket FCM Test!', // description
      importance: Importance.high,
    );
    //foreground 에서의 푸쉬 알람 표시를 위한 local notification 설정
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_noti');
    var initializationSettingsIOS = const IOSInitializationSettings();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS),
    );
    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? ios = message.notification?.apple;
      print("I got message in FOREGROUND\nMessage data: ${message.data['ID']}");
      if (notification != null && (android != null || ios != null)) {
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              enableVibration: true,
              channelShowBadge: true,
            ),
            iOS: const IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );
      }
    });
    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? ios = message.notification?.apple;
      //백그라운드에서 메시지를 받은 경우
      print("I got message in CLICKED\nMessage data: ${message.data['ID']}");
      if (notification != null && (android != null || ios != null)) {
        if (message.data['ID'].toString() == "1") {
          print('친구 신청');
          Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => const FriendMainScreen(
                index: 2,
              ),
            ),
          );
        } else if (message.data['ID'].toString() == "2") {
          print('친구 수락');
          Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => const FriendMainScreen(
                index: 0,
              ),
            ),
          );
        } else {
          print("데이터 없습니다.");
          return;
        }
      }
    });
    //Terminated
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("I got message in TERMINATED\nMessage data: ${message.data['ID']}");
      if (notification != null && android != null) {
        if (message.data['ID'].toString() == "1") {
          print('친구 신청(Terminate)');
          Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => const FriendMainScreen(
                index: 2,
              ),
            ),
          );
          //친구 수락(Friend Accept)
        } else if (message.data['ID'].toString() == "2") {
          print('친구 수락(Terminate)');
          Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => const FriendMainScreen(
                index: 0,
              ),
            ),
          );
        } else {
          print("데이터 없습니다.");
          return;
        }
      }
    }
  }

  @override
  FutureOr build() async {
    String token = await _messaging.getToken() ?? "";
    if (token == "") return;
    await initListener();
    _messaging.onTokenRefresh.listen((newToken) {
      token = newToken;
    });
  }
}

final notificationProvider = AsyncNotifierProvider(
  () => NotificationProvider(),
);
