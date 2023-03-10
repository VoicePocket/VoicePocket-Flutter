import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/recordroom/recordroom_studio_screen.dart';

class RecordroomMainScreen extends StatelessWidget {
  const RecordroomMainScreen({super.key});

  void _onCreateModelTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RecordroomStudioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          width: 55,
          height: 55,
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
                Text(
                  "Record Room",
                  style: TextStyle(
                    fontSize: Sizes.size40,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Gaps.v40,
                Container(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "모델 파일 이름",
                              style: TextStyle(
                                fontSize: Sizes.size36,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Gaps.v16,
                            Text(
                              "2022.01.29",
                              style: TextStyle(
                                fontSize: Sizes.size20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onPressed: () => _onCreateModelTab(context),
          child: const Icon(
            Icons.add_circle_outline_outlined,
            size: Sizes.size44,
          ),
        ),
      ),
    );
  }
}
