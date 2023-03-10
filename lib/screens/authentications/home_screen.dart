import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/recordroom/recordroom_main_screen.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_play_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onRecordTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RecordroomMainScreen(),
      ),
    );
  }

  void _onVoiceTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VoicePocketPlayScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
            vertical: Sizes.size40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'HOME',
                style: TextStyle(
                  fontSize: Sizes.size48,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v72,
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
                              Expanded(
                                child: Container(),
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
                child: GestureDetector(
                  onTap: () => _onVoiceTab(context),
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
                              Expanded(
                                child: Container(),
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
                                    "듣기",
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
      ),
    );
  }
}
