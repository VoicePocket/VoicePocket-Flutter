import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/screens/voicepocket/media_player_screen.dart';
import 'package:voicepocket/services/post_text.dart';
import 'package:voicepocket/services/token_refresh_post.dart';
import 'package:voicepocket/models/database_service.dart';
import 'package:voicepocket/services/message_tile.dart';

class PostTextScreenDemo extends StatefulWidget {
  final String email;
  const PostTextScreenDemo({super.key, required this.email});

  @override
  State<PostTextScreenDemo> createState() => _PostTextScreenDemoState();
}

class _PostTextScreenDemoState extends State<PostTextScreenDemo> {
  Stream<QuerySnapshot>? chats;
  final TextEditingController _textController = TextEditingController();
  TextModel? response;
  String inputText = "";
  bool isLoading = false;
  String defaultEmail = "";

  @override
  void initState() {
    getChat();
    super.initState();
    _textController.addListener(() {
      setState(() {
        inputText = _textController.text;
      });
    });
  }

  getChat() {
    DatabaseService().getChats(widget.email).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  void _postTextTab(String text) async {
    setState(() {
      isLoading = true;
    });
    var response = await postTextDemo(text, widget.email);
    if (!mounted) return;
    if (response.success) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MediaPlayerScreen(
            path: "${response.data.uuid}.wav",
            email: response.data.email,
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

  @override
  Widget build(BuildContext context) {
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
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: const Color.fromRGBO(243, 230, 255, 0.816),
              child: Row(
                children: [
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
                  InkWell(
                    onTap: () {
                      sendMessage(inputText);
                      _postTextTab(inputText);
                    },
                    child:Container(
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
  sendMessage(String text) async{
    final pref = await SharedPreferences.getInstance();
    defaultEmail = pref.getString("email")!;
    if (text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": text,
        "sender": defaultEmail,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessage(widget.email, chatMessageMap);
      setState(() {
        _textController.clear();
      });
    }
  }

chatMessages() {
  return StreamBuilder(
    stream: chats,
    builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData
          ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.email ==
                          snapshot.data.docs[index]['sender'],
                    ),
                    if (isLoading && index == snapshot.data.docs.length - 1)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 8.0,
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          : Container();
    },
  );
}
}