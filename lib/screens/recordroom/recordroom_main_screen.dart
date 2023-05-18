import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';

import '../authentications/home_screen.dart';

enum Progress {
  proceeding,
  completed,
  paused,
}

class RecordroomMainScreen extends StatefulWidget {
  const RecordroomMainScreen({super.key});

  @override
  State<RecordroomMainScreen> createState() => _RecordroomMainScreenState();
}

class _RecordroomMainScreenState extends State<RecordroomMainScreen> {
  late final SharedPreferences pref;
  String name = '', nickname = '';

  @override
  void initState() {
    super.initState();
    getSharedPreference();
  }

  Future<void> getSharedPreference() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("name")!;
      nickname = pref.getString("nickname")!;
    });
  }

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  String getProgress(Progress progress) {
    switch (progress) {
      case Progress.proceeding:
        return "진행중...";
      case Progress.completed:
        return "완료";
      case Progress.paused:
        return "중지";
    }
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size40,
            horizontal: Sizes.size16,
          ),
          child: Column(
            children: [
              Gaps.v20,
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.7),
                foregroundColor: Colors.white,
                radius: MediaQuery.of(context).size.width * 0.15,
                child: Icon(
                  Icons.account_circle_rounded,
                  size: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              Gaps.v10,
              Text(
                nickname,
                style: TextStyle(
                  fontSize: Sizes.size28,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Gaps.v48,
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size24,
                    horizontal: Sizes.size16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "모델 생성자",
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.v12,
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size24,
                    horizontal: Sizes.size16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "진행 상황",
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        getProgress(Progress.completed),
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.v12,
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size24,
                    horizontal: Sizes.size16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "요청 일자",
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "2023.05.17",
                        style: TextStyle(
                          fontSize: Sizes.size24,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
