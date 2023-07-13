import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/friendship_request_get_model.dart';
import 'package:voicepocket/services/request_friendship.dart';
import '../authentications/home_screen.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_select_action.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_select_action_friend.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final SharedPreferences _pref;
  String name = "", myName = "", myEmail = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      _pref = pref;
      setState(() {
        myName = _pref.getString("name")!;
        myEmail = _pref.getString("email")!;
      });
    });
  }

  void toHomeScreen(BuildContext context) {
    context.pushReplacementNamed(HomeScreen.routeName);
  }

  /// 내 페이지인지 친구 페이지인지 이메일로 판단하는 기능 추가
  void _onVoicePocketTab(
      BuildContext context, String name, String email) async {
    final pref = await SharedPreferences.getInstance();
    final defaultEmail = pref.getString("email")!;
    if (email != defaultEmail) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelectScreenFriend(name: name, email: email),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelectScreen(name: name, email: email),
        ),
      );
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
          child: FutureBuilder<List<DataG>>(
              future: getFriendShip,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      Text(
                        "모델 선택",
                        style: TextStyle(
                          fontSize: Sizes.size40,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Gaps.v40,
                      GestureDetector(
                        onTap: () =>
                            _onVoicePocketTab(context, myName, myEmail),
                        child: Card(
                          elevation: Sizes.size8,
                          shadowColor: Colors.black,
                          margin: const EdgeInsets.only(bottom: Sizes.size10),
                          color: const Color.fromARGB(255, 120, 104, 199),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Sizes.size16,
                              horizontal: Sizes.size20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$myName (My)",
                                      style: const TextStyle(
                                        fontSize: Sizes.size36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Gaps.v16,
                                    Text(
                                      myEmail,
                                      style: const TextStyle(
                                        fontSize: Sizes.size20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: Sizes.size28,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: Sizes.size24 + Sizes.size1,
                                    backgroundColor: Colors.deepPurple.shade300,
                                    child: const Icon(
                                      FontAwesomeIcons.arrowRight,
                                      color: Colors.white,
                                      size: Sizes.size32,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          String name = snapshot.data![index].requestTo.name;
                          String email = snapshot.data![index].requestTo.email;
                          return GestureDetector(
                            onTap: () =>
                                _onVoicePocketTab(context, name, email),
                            child: Card(
                              elevation: Sizes.size8,
                              shadowColor: Colors.black,
                              margin:
                                  const EdgeInsets.only(bottom: Sizes.size10),
                              color: Theme.of(context).primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size16,
                                  horizontal: Sizes.size20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: Sizes.size36,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Gaps.v16,
                                        Text(
                                          email,
                                          style: const TextStyle(
                                            fontSize: Sizes.size20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: Sizes.size28,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: Sizes.size24 + Sizes.size1,
                                        backgroundColor:
                                            Colors.deepPurple.shade300,
                                        child: const Icon(
                                          FontAwesomeIcons.arrowRight,
                                          color: Colors.white,
                                          size: Sizes.size32,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
