import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/recordroom/recordroom_studio_screen.dart';

import '../authentications/home_screen.dart';

class RecordroomMainScreen extends StatefulWidget {
  const RecordroomMainScreen({super.key});

  @override
  State<RecordroomMainScreen> createState() => _RecordroomMainScreenState();
}

class _RecordroomMainScreenState extends State<RecordroomMainScreen> {
  var containers = <Container>[];

  void _onCreateModelTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RecordroomStudioScreen(),
      ),
    );
  }

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
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
              Expanded(
                child: ListView.builder(
                  itemCount: containers.length,
                  itemBuilder: (context, index) => containers[index],
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.minimize,
                        size: Sizes.size40,
                      ),
                      onPressed: () {
                        setState(() {
                          containers.remove(containers.last);
                        });
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: Sizes.size40,
                      ),
                      onPressed: () {
                        setState(() {
                          containers.add(modelcontainer());
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
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

  Container modelcontainer() {
    return Container(
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
    );
  }
}
