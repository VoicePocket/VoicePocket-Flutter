import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import '../authentications/home_screen.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_play_screen.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

    void _onVoicePocketTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VoicePocketPlayScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          width: 55,
          height: 55,
        ),
        leading: IconButton(
          icon: const Icon(Icons.house),
          onPressed: () => toHomeScreen(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size40,
              horizontal: Sizes.size16,
            ),
            child: Column(
              children: [
                /* Text(
                  "",
                  style: TextStyle(
                    fontSize: Sizes.size40,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ), */
                GestureDetector(
                  child:Container(
                  margin: const EdgeInsets.only(bottom: Sizes.size10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.size16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size16,
                      horizontal: Sizes.size20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "친구에게 전송",
                              style: TextStyle(
                                fontSize: Sizes.size36,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )             
                ),
                GestureDetector(
                  onTap: () => _onVoicePocketTab(context),
                  child:Container(
                  margin: const EdgeInsets.only(bottom: Sizes.size10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.size16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size16,
                      horizontal: Sizes.size20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "재생",
                              style: TextStyle(
                                fontSize: Sizes.size36,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )             
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
