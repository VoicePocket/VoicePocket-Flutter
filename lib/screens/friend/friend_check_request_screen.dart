import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/services/request_friendship.dart';

class FriendCheckRequestScreen extends StatelessWidget {
  const FriendCheckRequestScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size20,
          vertical: Sizes.size10,
        ),
        child: FutureBuilder<List<String>>(
          future: getFriendShipRequest,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<String> nameList = snapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String name = nameList[index];
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
                            backgroundImage: NetworkImage(
                                "https://picsum.photos/id/48/200/300"),
                          ),
                        ),
                        title: Text(
                          name,
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
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.check,
                                    textDirection: TextDirection.rtl,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.xmark,
                                    textDirection: TextDirection.rtl,
                                    size: 20,
                                    color: Colors.red,
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
        ),
      ),
    );
  }
}
