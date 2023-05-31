import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //백그라운드에서 메시지를 받은 경우
  print('Handling a background message ${message.notification!.body}');
}

Future<String?> fcmSetting() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print("User granted permission: ${settings.authorizationStatus}");

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

  //foreground 푸쉬 알림 핸들링
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    print("I got message in foreground\nMessage data: ${message.data}");

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
      print("Message contained a notification: ${message.notification}");
    }
  });

  String? firebaseToken = await messaging.getToken();
  print("firebaseToken: $firebaseToken");
  return firebaseToken;
}
