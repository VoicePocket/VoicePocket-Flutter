import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/models/friendship_request_get_model.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/services/request_friendship.dart';

class FriendCheckRequestScreen extends StatefulWidget {
  const FriendCheckRequestScreen({super.key});

  @override
  State<FriendCheckRequestScreen> createState() =>
      _FriendCheckRequestScreenState();
}

class _FriendCheckRequestScreenState extends State<FriendCheckRequestScreen> {
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
        child: FutureBuilder<List<DataG>>(
          future: getFriendShipRequest,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<DataG> dataList = snapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  String name = dataList[index].requestFrom.name;
                  String email = dataList[index].requestFrom.email;
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final success =
                                          await acceptFriendShip(email);
                                      setState(() {
                                        if (success) {
                                          dataList.remove(dataList[index]);
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
                                      final success =
                                          await rejectFriendShip(email);
                                      setState(() {
                                        if (success) {
                                          dataList.remove(dataList[index]);
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
        ),
      ),
    );
  }
}
