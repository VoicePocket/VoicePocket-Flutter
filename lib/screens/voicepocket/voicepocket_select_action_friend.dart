import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/voicepocket/post_text_screen_demo_friend.dart';
import 'package:voicepocket/services/google_cloud_service.dart';
import '../authentications/home_screen.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_play_screen copy.dart';
import 'package:voicepocket/models/database_service.dart';

class SelectScreenFriend extends StatefulWidget {
  final String name, email;
  const SelectScreenFriend(
      {super.key, required this.name, required this.email});

  @override
  State<SelectScreenFriend> createState() => _SelectScreenFriendState();
}

class _SelectScreenFriendState extends State<SelectScreenFriend> {
  String defaultEmail = "", defaultName = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    createFolder();
    createFireStore();
  }

  Future<void> createFireStore() async {
    defaultEmail = widget.email;
    defaultName = widget.name;

    DatabaseService().savingUserData(defaultName, defaultEmail);

    /* if(DatabaseService().gettingUserData(defaultEmail) == "") {
      DatabaseService().savingUserData(defaultName, defaultEmail);
      print('firestore create');
    } */
  }

  Future<void> createFolder() async {
    defaultEmail = widget.email;
    final routeDir = await getPublicDownloadFolderPath();
    final defaultDir = Directory('${routeDir.path}/wav/$defaultEmail');

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (!(await defaultDir.exists())) {
      defaultDir.create();
    }
  }

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void _onVoicePocketTab(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoicePocketPlayScreenCopy(
          email: defaultEmail,
        ),
      ),
    );
  }

  void _onPostTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostTextScreenDemoFriend(
          email: defaultEmail,
        ),
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
      body: Center(
        child: isLoading
            ? Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 8.0,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size40,
                  horizontal: Sizes.size16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => _onPostTab(context),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.5,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "음성\n만들기",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Sizes.size40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onVoicePocketTab(context),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.5,
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
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "음성\n보관함",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: Sizes.size40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
