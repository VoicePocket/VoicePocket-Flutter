import 'package:flutter/material.dart';
import 'package:voicepocket/constants/sizes.dart';

import '../../constants/gaps.dart';
import '../authentications/home_screen.dart';

class FriendMainScreen extends StatefulWidget {
  const FriendMainScreen({super.key});

  @override
  State<FriendMainScreen> createState() => _FriendMainScreenState();
}

class _FriendMainScreenState extends State<FriendMainScreen> {
  final TextEditingController _friendController = TextEditingController();
  String _friend = "";

  @override
  void initState() {
    super.initState();
    _friendController.addListener(() {
      setState(() {
        _friend = _friendController.text;
      });
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

  final List<Widget> _cardList = [];

  void _addCardWidget() {
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
                  onPressed: () {
                    if (!isFriendValid()) {
                      return;
                    }
                    setState(() {
                      _cardList.add(
                        card(_friend, _cardList.length),
                      );
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

  void _subCardWidget() {
    setState(() {
      if (_cardList.isNotEmpty) {
        _cardList.removeLast();
      }
    });
  }

  Widget card(String email, int index) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 26,
              backgroundImage:
                  NetworkImage("https://picsum.photos/id/48/200/300"),
            ),
          ),
          title: Text(
            email,
            style: TextStyle(
              fontSize: Sizes.size16,
              fontWeight: FontWeight.w700,
              color: Colors.deepPurple.shade800,
            ),
          ),
          subtitle: const Text(
            'Freedom Fighter',
            style: TextStyle(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$index',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    const Icon(
                      Icons.access_alarms_outlined,
                      textDirection: TextDirection.rtl,
                      size: 20,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cardList.length,
                itemBuilder: (context, index) {
                  return _cardList[index];
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: _addCardWidget,
                  tooltip: 'Add',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: _subCardWidget,
                  tooltip: 'Sub',
                  child: const Icon(Icons.minimize_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
