import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/screens/friend/friend_main_screen.dart';
import 'package:voicepocket/screens/voicepocket/media_player_screen.dart';
import 'package:voicepocket/services/google_cloud_service.dart';
import 'package:voicepocket/models/database_service.dart';

import 'global_var.dart';

class NotificationProvider extends AsyncNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String defaultEmail = "";

  //메시지 전송 함수
  sendMessage(String text) async{
    final pref = await SharedPreferences.getInstance();
    defaultEmail = pref.getString("email")!;
    if (text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": text,
        "sender": 'SERVER',
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessage(defaultEmail, chatMessageMap);
    }
  }

  //FCM 상태는 3가지(Back / Fore / Terminated)
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
      'VoicePocketNotificationName1',
      description: 'VoicePocket FCM Test!', // description
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: false,
    );
    //foreground 에서의 푸쉬 알람 표시를 위한 local notification 설정
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("I got message in FOREGROUND\nMessage data: ${message.data['ID']}");
      if (message.notification != null && android != null) {
        await flutterLocalNotificationsPlugin.initialize(
            InitializationSettings(android: initializationSettingsAndroid));
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              enableVibration: true,
              channelShowBadge: true,
            ),
          ),
        );
        if (message.data['ID'].toString() == "3") {
          final wavUrl = message.data['wavUrl'];
          await readWavFileFromNotification(wavUrl);
          if (message.data['wavUrl'].endsWith('.wav')) {
            final pref = await SharedPreferences.getInstance();
            defaultEmail = pref.getString("email")!;

            //파이어베이스에 서버 명의로 메시지 전송
            Map<String, dynamic> chatMessageMap = {
              "message": "https://storage.googleapis.com/voicepocket/$wavUrl",
              "sender": 'SERVER',
              "time": DateTime.now().millisecondsSinceEpoch,
            };

            final notiEmail = wavUrl.split("/")[0];
            print(notiEmail);

            if (defaultEmail == notiEmail){
              DatabaseService().sendMessage(defaultEmail, chatMessageMap);
            }
            else{
              DatabaseService().sendMessageForFriend(defaultEmail, notiEmail , chatMessageMap);
            }
            /* Navigator.of(GlobalVariable.navState.currentContext!).push(
              MaterialPageRoute(
                builder: (context) => MediaPlayerScreen(
                  email: wavUrl.split("/")[0],
                  path: wavUrl.split("/")[1],
                ),
              ),
            ); */
            return;
          }
          //친구 신청(Frined Request)
        } else if (message.data['ID'].toString() == "1") {
          Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => const FriendMainScreen(
                index: 2,
              ),
            ),
          );
          //친구 수락(Friend Accept)
        } else if (message.data['ID'].toString() == "2") {
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
    //Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      //백그라운드에서 메시지를 받은 경우
      print("I got message in BACKGROUND\nMessage data: ${message.data['ID']}");
      if (message.data['wavUrl'] != null) {
        final wavUrl = message.data['wavUrl'];
        await readWavFileFromNotification(wavUrl);
        if (message.data['wavUrl'].endsWith('.wav')) {
          final pref = await SharedPreferences.getInstance();
            defaultEmail = pref.getString("email")!;

          //파이어베이스에 서버 명의로 메시지 전송
            Map<String, dynamic> chatMessageMap = {
              "message": "https://storage.googleapis.com/voicepocket/$wavUrl",
              "sender": 'SERVER',
              "time": DateTime.now().millisecondsSinceEpoch,
            };

            final notiEmail = wavUrl.split("/")[0];

            if (defaultEmail == notiEmail){
              DatabaseService().sendMessage(defaultEmail, chatMessageMap);
            }
            else{
              DatabaseService().sendMessageForFriend(defaultEmail, notiEmail , chatMessageMap);
            }
          /* Navigator.of(GlobalVariable.navState.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => MediaPlayerScreen(
                email: wavUrl.split("/")[0],
                path: wavUrl.split("/")[1],
              ),
            ),
          ); */
          return;
        }
        //친구 신청(Frined Request)
      } else if (message.notification!.title!.contains("Request")) {
        Navigator.of(GlobalVariable.navState.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => const FriendMainScreen(
              index: 2,
            ),
          ),
        );
        //친구 수락(Friend Accept)
      } else if (message.notification!.title!.contains("Accept")) {
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
    });
    //Terminated
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      print("I got message in TERMINATED\nMessage data: ${message.data['ID']}");
      if (message.data['wavUrl'] != null) {
        final wavUrl = message.data['wavUrl'];
        await readWavFileFromNotification(wavUrl);
        if (message.data['wavUrl'].endsWith('.wav')) {
          final pref = await SharedPreferences.getInstance();
            defaultEmail = pref.getString("email")!;

          //파이어베이스에 서버 명의로 메시지 전송
            Map<String, dynamic> chatMessageMap = {
              "message": "https://storage.googleapis.com/voicepocket/$wavUrl",
              "sender": 'SERVER',
              "time": DateTime.now().millisecondsSinceEpoch,
            };

            final notiEmail = wavUrl.split("/")[0];
            
            if (defaultEmail == notiEmail){
              DatabaseService().sendMessage(defaultEmail, chatMessageMap);
            }
            else{
              DatabaseService().sendMessageForFriend(defaultEmail, notiEmail , chatMessageMap);
            }
          return;
        }
      } 
    }
  }

  @override
  FutureOr build() async {
    String token = await _messaging.getToken() ?? "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (token == "") return;
    await initListener();
    _messaging.onTokenRefresh.listen((newToken) {
      token = newToken;
    });
    //pref.setString("fcmToken", token);
  }
}

final notificationProvider = AsyncNotifierProvider(
  () => NotificationProvider(),
);
