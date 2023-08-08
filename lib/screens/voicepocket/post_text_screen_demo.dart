//현재 사용 중인 페이지
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/post_text.dart';
import 'package:voicepocket/services/token_refresh_post.dart';
import 'package:voicepocket/models/database_service.dart';
import 'package:voicepocket/widgets/message_tile.dart';
import 'package:voicepocket/widgets/message_tile_indicator.dart';

import '../authentications/home_screen.dart';

class PostTextScreenDemo extends StatefulWidget {
  final String email;
  const PostTextScreenDemo({
    super.key,
    required this.email,
  });

  @override
  State<PostTextScreenDemo> createState() => _PostTextScreenDemoState();
}

class _PostTextScreenDemoState extends State<PostTextScreenDemo> {
  Stream<QuerySnapshot>? chats;
  final TextEditingController _textController = TextEditingController();
  TextModel? response;
  String inputText = "";
  String wavUrl = "";
  String defaultEmail = "";
  List<QueryDocumentSnapshot> listMessage = [];
  late AudioPlayer audioPlayer = audioPlayer;
  final BehaviorSubject<PlayerState> _playerStateSubject =
      BehaviorSubject<PlayerState>();
  late ScrollController _scrollController;


  @override
  void initState() {
    getChat();
    super.initState();

    _scrollController = ScrollController();

    // 리스트 뷰의 스크롤 위치가 변경될 때마다 호출되는 리스너를 추가합니다.
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        // 리스트 뷰의 맨 아래로 스크롤하려는 경우, 더 많은 메시지를 로드합니다.
        loadMoreMessages();
      }
    });

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

  getChat() {
    DatabaseService().getChats(widget.email).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  Future<String> _postTextTab(String text) async {
    final pref = await SharedPreferences.getInstance();
    final uuid = const Uuid().v1();
    final wavUrl = '${widget.email}/$uuid.wav';
    final notiEmail = widget.email;
    defaultEmail = pref.getString("email")!;
    setState(() {
    });
    var response = await postTextDemo(text, widget.email, uuid);
    if (response.success) {
      setState(() {
      });
      print(wavUrl);
      return wavUrl;
    } else if (response.code == -1006) {
      await tokenRefreshPost();
      return '토큰 만료';
    } else {
      return '';
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
        //키보드 제외 영역 터치시 키보드 감춤 기능
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          //스크롤뷰로 감싸 키보드 팝업 시 채팅창이 키보드 위로 올라가게 함
          child:
          SingleChildScrollView(
          //controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              chatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(243, 230, 255, 0.816),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
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
                      /* const SizedBox(
                        width: 12,
                      ), */
                      InkWell(
                        onTap: () async {
                          sendMessage(inputText);
                          wavUrl = await _postTextTab(inputText);
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
        ))
    );
  }

  Future<void> loadMoreMessages() async {
    // 가장 마지막 메시지의 시간을 기준으로 이전 메시지 20개를 가져옴
    final lastMessageTime = listMessage.isNotEmpty
        ? listMessage.first['time']
        : DateTime.now().millisecondsSinceEpoch;

    final moreChats =
        await getMoreChats(widget.email, lastMessageTime);

    setState(() {
      listMessage.insertAll(0, moreChats.docs);
    });
  }

  Future<QuerySnapshot> getMoreChats(String email, int lastMessageTime) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('sender', isEqualTo: email)
        .where('time', isLessThan: lastMessageTime)
        .orderBy('time', descending: true)
        .limit(20)
        .get();

    return querySnapshot;
  } catch (e) {
    print("Error getting more chats: $e");
    rethrow; // 예외를 다시 던져서 상위 호출자에서 처리하도록 함
  }
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
    height: MediaQuery.of(context).size.height * 0.79,
    child: StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            // 리스트 뷰가 다시 그려진 후에 아래로 스크롤합니다.
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: _scrollController, // ScrollController를 지정합니다.
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MessageTile(
                    wavUrl: wavUrl,
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.email == snapshot.data.docs[index]['sender'],
                  ),
                ],
              );
            },
          );
        } else {
          return Container();
        }
      },
    ),
  );
}

}
