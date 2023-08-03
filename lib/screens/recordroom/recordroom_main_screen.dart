import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/recordroom/recordroom_studio_screen.dart';

import '../authentications/home_screen.dart';

enum Progress {
  proceeding,
  completed,
  paused,
}

class RecordroomMainScreen extends StatefulWidget {
  static const routeName = 'recordroom-main-screen';
  final Map<String, List<String>> metaData;
  final int modelIndex;
  const RecordroomMainScreen(
      {super.key, required this.metaData, required this.modelIndex});

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

  void reRecord() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RecordroomStudioScreen(
          metaData: widget.metaData,
          modelIndex: widget.modelIndex - 1,
        ),
      ),
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

  void reRecordDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "친구 신청",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const [
                    Text("상대의 이메일을 입력하시오."),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => reRecord(),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.size10),
                        side: const BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  child: const Text(
                    "요청",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.size10),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  child: const Text(
                    "취소",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          });
        });
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
            icon: const Icon(FontAwesomeIcons.repeat),
            onPressed: () => reRecordDialog(),
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
