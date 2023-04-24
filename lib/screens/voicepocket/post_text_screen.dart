import 'package:flutter/material.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/screens/voicepocket/media_player_screen.dart';
import 'package:voicepocket/services/post_text.dart';
import 'package:voicepocket/services/token_refresh_post.dart';

class PostTextScreen extends StatefulWidget {
  const PostTextScreen({super.key});

  @override
  State<PostTextScreen> createState() => _PostTextScreenState();
}

class _PostTextScreenState extends State<PostTextScreen> {
  final TextEditingController _textController = TextEditingController();
  TextModel? response;
  String inputText = "";

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        inputText = _textController.text;
      });
    });
  }

  void _postTextTab(String text) async {
    var response = await postText(text);
    if (!mounted) return;
    if (response.success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MediaPlayerScreen(
            path: "${response.data.uuid}.wav",
          ),
        ),
      );
    } else if (response.code == -1006) {
      await tokenRefreshPost();
    } else {
      return;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget chatMessages() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 4,
          ),
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(left: 30),
            padding:
                const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "User",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(inputText,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16, color: Colors.white))
              ],
            ),
          ),
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double buttonsize = MediaQuery.of(context).size.width * 0.3;
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          width: MediaQuery.of(context).size.height * 0.1,
          height: 55,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          if (inputText != "") chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: const Color.fromRGBO(243, 230, 255, 0.816),
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "메시지를 입력하세요.",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                /* IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => {chatMessages(),_postTextTab(inputText)}, 
                  icon: const Icon(Icons.send),
                ), */
                InkWell(
                  onTap: () {
                    _postTextTab(inputText);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}