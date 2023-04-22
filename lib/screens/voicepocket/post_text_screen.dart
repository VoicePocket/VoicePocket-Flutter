import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
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

  void _postTextTab(String text) async {
    var response = await postText(text);
    if (!mounted) return;
    if (response.success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MediaPlayerScreen(
            path: response.data.wavUrl.split("/")[1],
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
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        inputText = _textController.text;
      });
    });
  }

  void _onListenTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MediaPlayerScreen(
          path: response!.data.wavUrl.split("/")[1],
        ),
      ),
    );
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
          width: 55,
          height: 55,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textController,
                style: const TextStyle(
                  fontSize: Sizes.size24,
                ),
              ),
              Gaps.v48,
              CupertinoButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => _postTextTab(inputText),
                child: const Text(
                  "POST",
                  style: TextStyle(
                    fontSize: Sizes.size24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
