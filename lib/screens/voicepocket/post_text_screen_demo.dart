import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/post_text.dart';
import 'package:voicepocket/services/token_refresh_post.dart';
import 'package:voicepocket/models/database_service.dart';
import 'package:voicepocket/widgets/message_tile.dart';
import 'package:voicepocket/widgets/message_tile_indicator.dart';

import '../authentications/home_screen.dart';

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
  late ScrollController _scrollController;
  List<QueryDocumentSnapshot> listMessage = [];
  late AudioPlayer audioPlayer = audioPlayer;
  final BehaviorSubject<PlayerState> _playerStateSubject =
      BehaviorSubject<PlayerState>();

  bool isUILoading = false;
  bool bottomFlag = true;
  bool isScrollBottomFixed = true;

  @override
  void initState() {
    getChat();
    super.initState();
    bool isUILoading = false;
    bool bottomFlag = true;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _textController.addListener(() {
      setState(() {
        inputText = _textController.text;
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

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        isScrollBottomFixed = true;
      });
    } else {
      setState(() {
        isScrollBottomFixed = false;
      });
    }
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
    } else if (response.code == -1006) {
      await tokenRefreshPost();
    } else {
      return;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    audioPlayer.dispose();
    _playerStateSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Image.asset(
            "assets/images/logo.png",
            width: MediaQuery.of(context).size.height * 0.1,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              chatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  height: MediaQuery.of(context).size.height * 0.1,
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
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
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
                          bottomFlag = true;
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
        ));
  }

  sendMessage(String text) async {
    final pref = await SharedPreferences.getInstance();
    defaultEmail = pref.getString("email")!;
    if (text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": text,
        "sender": defaultEmail,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessage(defaultEmail, chatMessageMap);

      setState(() {
        _textController.clear();
      });
    }
  }

  chatMessages() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: StreamBuilder(
          stream: chats,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MessageTile(
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            sentByMe: widget.email ==
                                snapshot.data.docs[index]['sender'],
                          ),
                          if (isLoading &&
                              index == snapshot.data.docs.length - 1)
                            const MessageTileIndicator(),
                        ],
                      );
                    },
                  )
                : Container();
          },
        ));
  }
}
