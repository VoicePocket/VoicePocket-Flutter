import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_play_screen.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/screens/voicepocket/post_text_screen.dart';

void main() async{
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const VoicePocketPlayScreen(),
    );
  }
}
