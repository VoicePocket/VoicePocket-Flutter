import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/main_screen.dart';
import 'package:voicepocket/screens/friend/friend_main_screen.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_list_screen.dart';
import 'package:voicepocket/services/google_cloud_service.dart';
import 'package:voicepocket/services/load_csv.dart';

import '../recordroom/recordroom_studio_screen_test.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late Map<String, List<String>> metaData;
  List<int> modelIndexList = [];
  int modelIndex = 0;

  @override
  void initState() {
    super.initState();
    //loadCSV().then((value) => metaData = value);
    loadRandomCSV().then((value) => metaData = value);
    getPublicDownloadFolderPath().then((dir) async {
      // final modelDir = Directory("${dir.path}/model");
      final modelDir = Directory("${dir.path}/model/test");
      if (await modelDir.list().isEmpty) {
        return;
      } else {
        for (var file in modelDir.listSync()) {
          if (file.path.endsWith(".wav")) {
            int fileNum = int.parse(file.path.split("/").last.substring(6, 9));
            modelIndexList.add(fileNum);
          }
        }
        modelIndexList.sort();
        modelIndex = modelIndexList.last;
      }
    });
  }

  void _onRecordTab(BuildContext context) {
    // Navigator.of(context).pushNamed(
    //   modelIndex == 315
    //       ? RecordroomMainScreen.routeName
    //       : RecordroomStudioScreen.routeName,
    //   arguments: {'metaData': metaData, 'modelIndex': modelIndex},
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => modelIndex == metaData['name']!.length
            ? RecordroomStudioTestScreen(
                metaData: metaData,
                modelIndex: modelIndex - 1,
              )
            : RecordroomStudioTestScreen(
                metaData: metaData,
                modelIndex: modelIndex,
              ),
      ),
    );
  }

  void _onFriendTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FriendMainScreen(
          index: 0,
        ),
      ),
    );
  }

  void _onLogoutTab(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("로그아웃"),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.grey,
      ),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
      (route) => false,
    );
    pref.clear();
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
      resizeToAvoidBottomInset: false,
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
              flex: 3,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "내 목소리 만들기",
                              style: TextStyle(
                                fontSize: Sizes.size24,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
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
              flex: 3,
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
            Flexible(
              fit: FlexFit.loose,
              flex: 2,
              child: GestureDetector(
                onTap: () => _onFriendTab(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFFD8BBFF),
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
                              "친구에게\n내 목소리를\n전달해보세요.",
                              style: TextStyle(
                                fontSize: Sizes.size16,
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
                                  "만나러 가기",
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
                          Icons.people_alt,
                          color: Colors.grey.shade800,
                          size: Sizes.size96 + Sizes.size20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
