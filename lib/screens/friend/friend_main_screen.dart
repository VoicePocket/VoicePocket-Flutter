import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/friendship_request_get_model.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_select_action.dart';
import 'package:voicepocket/services/request_friendship.dart';
import 'package:voicepocket/widgets/nav_tab.dart';

import '../../constants/gaps.dart';
import '../authentications/home_screen.dart';

class FriendMainScreen extends StatefulWidget {
  final int index;
  const FriendMainScreen({super.key, required this.index});

  @override
  State<FriendMainScreen> createState() => _FriendMainScreenState();
}

class _FriendMainScreenState extends State<FriendMainScreen> {
  final TextEditingController _friendController = TextEditingController();
  String _friend = "";
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _friendController.addListener(() {
      setState(() {
        _friend = _friendController.text;
      });
    });
  }

  void toVoiceSelect(BuildContext context, String name, String email) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectScreen(
          name: name,
          email: email,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool isFriendValid() {
    return (_friend.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_friend));
  }

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void _requestFriend() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, diaSetState) {
            return AlertDialog(
              title: const Text(
                "친구 신청",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const Text("상대의 이메일을 입력하시오."),
                    Gaps.v20,
                    TextField(
                      controller: _friendController,
                      onChanged: (text) {
                        diaSetState(() {
                          isFriendValid();
                        });
                      },
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size16 + Sizes.size2,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: '이메일',
                        hintStyle: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size10,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (!isFriendValid()) {
                      return;
                    }
                    final friend = await requestFriendShip(_friend);
                    setState(() {
                      if (friend.success) {
                        _friendController.clear();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(friend.message),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.red.shade500,
                          ),
                        );
                      }
                      _friendController.clear();
                      Navigator.of(context).pop();
                    });
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.size10),
                        side: BorderSide(
                          color: isFriendValid()
                              ? Colors.green
                              : Colors.green.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    "요청",
                    style: TextStyle(
                      color: isFriendValid()
                          ? Colors.green
                          : Colors.green.withOpacity(0.5),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _friendController.clear();
                    Navigator.of(context).pop();
                  },
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
  void dispose() {
    _friendController.dispose();
    super.dispose();
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
      body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
            vertical: Sizes.size10,
          ),
          child: (_currentIndex == 0)
              // 친구 목록
              ? FutureBuilder<List<DataG>>(
                  future: getFriendShip,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<DataG> dataList = snapshot.data!;
                      return ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          String name = dataList[index].requestTo.name;
                          String email = dataList[index].requestTo.email;
                          return Container(
                            height: 90,
                            margin: const EdgeInsets.only(
                                top: 5, left: 8, right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: ListTile(
                                  onTap: () async {
                                    toVoiceSelect(context, name, email);
                                  },
                                  leading: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: const Icon(
                                        FontAwesomeIcons.user,
                                        color: Colors.white,
                                        size: Sizes.size28,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: Sizes.size20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                  ),
                                  subtitle: Text(
                                    email,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Sizes.size14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: CircleAvatar(
                                    radius: Sizes.size20 + Sizes.size2,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: Sizes.size20,
                                      backgroundColor:
                                          Colors.deepPurple.shade300,
                                      child: const Icon(
                                        FontAwesomeIcons.arrowRight,
                                        color: Colors.white,
                                        size: Sizes.size20,
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        },
                      );
                    }
                  },
                )
              : FutureBuilder<List<DataG>>(
                  future: getFriendShipRequest,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<DataG> dataList = snapshot.data!;
                      return ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          String name = dataList[index].requestFrom.name;
                          String email = dataList[index].requestFrom.email;
                          return Container(
                            height: 80,
                            margin: const EdgeInsets.only(
                                top: 5, left: 8, right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: const Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.white,
                                      size: Sizes.size28,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: Sizes.size20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                subtitle: Text(
                                  email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Sizes.size14,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SizedBox(
                                      width: 50,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              final accept =
                                                  await acceptFriendShip(email);
                                              setState(() {
                                                if (accept.success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text("이제 친구입니다."),
                                                      duration:
                                                          Duration(seconds: 1),
                                                      backgroundColor:
                                                          Color(0xFFA594F9),
                                                    ),
                                                  );
                                                  dataList
                                                      .remove(dataList[index]);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text(accept.message),
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      backgroundColor:
                                                          Colors.red.shade500,
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              FontAwesomeIcons.check,
                                              textDirection: TextDirection.rtl,
                                              size: 20,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 1,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final reject =
                                                  await rejectFriendShip(email);
                                              setState(() {
                                                if (reject.success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "친구 요청을 거절 하셨습니다."),
                                                      duration:
                                                          Duration(seconds: 1),
                                                      backgroundColor:
                                                          Color(0xFFA594F9),
                                                    ),
                                                  );
                                                  dataList
                                                      .remove(dataList[index]);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text(reject.message),
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      backgroundColor:
                                                          Colors.red.shade500,
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              FontAwesomeIcons.xmark,
                                              textDirection: TextDirection.rtl,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                )),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavTab(
                selectedIcon: FontAwesomeIcons.solidCircleUser,
                icon: FontAwesomeIcons.circleUser,
                label: "친구 목록",
                isSelected: _currentIndex == 0,
                onTab: () => _onItemTapped(0),
                containerColor: Theme.of(context).primaryColor,
              ),
              GestureDetector(
                onTap: () => _requestFriend(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size8,
                            ),
                            height: Sizes.size32,
                            width: Sizes.size24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF61D4F0),
                              borderRadius: BorderRadius.circular(
                                Sizes.size11,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size8,
                            ),
                            height: Sizes.size32,
                            width: Sizes.size24,
                            decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              borderRadius: BorderRadius.circular(
                                Sizes.size11,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size10,
                          ),
                          height: Sizes.size32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              Sizes.size11,
                            ),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.black,
                              size: Sizes.size20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gaps.v10,
                    const Text(
                      "친구 추가",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              NavTab(
                selectedIcon: FontAwesomeIcons.solidCircleDown,
                icon: FontAwesomeIcons.circleDown,
                label: "받은 신청",
                isSelected: _currentIndex == 2,
                onTab: () => _onItemTapped(2),
                containerColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
