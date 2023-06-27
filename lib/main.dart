import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/screens/authentications/main_screen.dart';
import 'package:voicepocket/screens/authentications/submit_info_screen.dart';
import 'package:voicepocket/screens/authentications/submit_nickname_screen.dart';
import 'package:voicepocket/screens/authentications/submit_term_screen.dart';
import 'package:voicepocket/services/notification_provider.dart';
import 'package:voicepocket/services/global_var.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //String? firebaseToken = await fcmSetting();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationProvider);
    return MaterialApp(
      navigatorKey: GlobalVariable.navState,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "contents_font",
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primaryColor: const Color(0xFFA594F9),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFA594F9),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(Sizes.size10),
            ),
          ),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const MainScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
        SubmitInfoScreen.routeName: (context) => const SubmitInfoScreen(),
        SubmitNicknameScreen.routeName: (context) =>
            const SubmitNicknameScreen(),
        SubmitTermScreen.routeName: (context) => const SubmitTermScreen(),
      },
      //home: const PostTextScreen(),
    );
  }
}
