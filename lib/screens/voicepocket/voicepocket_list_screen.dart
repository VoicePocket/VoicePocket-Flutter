import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import '../authentications/home_screen.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_select_action.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final SharedPreferences _pref;
  String email = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      _pref = pref;
      setState(() {
        email = _pref.getString("email")!;
      });
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

  void _onVoicePocketTab(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectScreen(index: index),
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
                Text(
                  "Select Model",
                  style: TextStyle(
                    fontSize: Sizes.size40,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Gaps.v40,
                GestureDetector(
                  onTap: () => _onVoicePocketTab(context, 0),
                  child: Container(
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
                            children: [
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: Sizes.size36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Gaps.v16,
                              const Text(
                                "2023.04.27",
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
                ),
                GestureDetector(
                  onTap: () => _onVoicePocketTab(context, 1),
                  child: Container(
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
                                "man@gmail.com",
                                style: TextStyle(
                                  fontSize: Sizes.size36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Gaps.v16,
                              Text(
                                "2023.04.27",
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
                ),
                GestureDetector(
                  onTap: () => _onVoicePocketTab(context, 2),
                  child: Container(
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
                                "woman@gmail.com",
                                style: TextStyle(
                                  fontSize: Sizes.size36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Gaps.v16,
                              Text(
                                "2023.04.27",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
