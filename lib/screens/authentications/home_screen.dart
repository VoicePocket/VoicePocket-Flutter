import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/main_screen.dart';
import 'package:voicepocket/screens/recordroom/recordroom_studio_screen.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    createFolder();
  }

  void _onRecordTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RecordroomStudioScreen(),
      ),
    );
  }

  void _onLogoutTab(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    Fluttertoast.showToast(
      msg: "로그아웃",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: const Color(0xFFA594F9),
      fontSize: Sizes.size16,
    );
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> createFolder() async {
    final routeDir = await getApplicationDocumentsDirectory();
    print("default 저장 경로: ${routeDir.path}");
    final modelDir = Directory('${routeDir.path}/model');
    final wavDir = Directory('${routeDir.path}/wav');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (!(await modelDir.exists())) {
      modelDir.create();
    }
    if (!(await wavDir.exists())) {
      wavDir.create();
    }
  }

  void _onVoicePocketListTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size20,
          vertical: Sizes.size40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v32,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'HOME',
                  style: TextStyle(
                    fontFamily: 'contests_fonts',
                    fontSize: Sizes.size40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    _onLogoutTab(context);
                  },
                  icon: const Icon(
                    Icons.logout_sharp,
                    size: Sizes.size48,
                  ),
                ),
              ],
            ),
            Gaps.v64,
            Flexible(
              fit: FlexFit.loose,
              child: GestureDetector(
                onTap: () => _onRecordTab(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFFAFB1FF),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "내 목소리 만들기",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size10,
                                  horizontal: Sizes.size32,
                                ),
                                child: Text(
                                  "녹음 하기",
                                  style: TextStyle(
                                    fontSize: Sizes.size16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          FontAwesomeIcons.microphone,
                          color: Colors.grey.shade800,
                          size: Sizes.size96 + Sizes.size20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Gaps.v16,
            Flexible(
              fit: FlexFit.loose,
              child: GestureDetector(
                onTap: () => _onVoicePocketListTab(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFFBBD0FF),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Voice Pocket",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size10,
                                  horizontal: Sizes.size32,
                                ),
                                child: Text(
                                  "GO",
                                  style: TextStyle(
                                    fontSize: Sizes.size16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.equalizer,
                          color: Colors.grey.shade800,
                          size: Sizes.size96 + Sizes.size20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Gaps.v16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0XFFD8BBFF),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "친구에게",
                            style: TextStyle(
                              fontSize: Sizes.size16 + Sizes.size2,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Gaps.v8,
                          const Text(
                            "요청해보세요!",
                            style: TextStyle(
                              fontSize: Sizes.size16 + Sizes.size2,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Gaps.v5,
                          Icon(
                            Icons.people_alt,
                            size: Sizes.size28,
                            color: Colors.grey.shade800,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Gaps.h16,
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0XFFD8BBFF),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "친구에게",
                            style: TextStyle(
                              fontSize: Sizes.size16 + Sizes.size2,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Gaps.v8,
                          const Text(
                            "요청해보세요!",
                            style: TextStyle(
                              fontSize: Sizes.size16 + Sizes.size2,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Gaps.v5,
                          Icon(
                            Icons.people_alt,
                            size: Sizes.size28,
                            color: Colors.grey.shade800,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
