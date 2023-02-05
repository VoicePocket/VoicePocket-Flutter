import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/models/text_model.dart';
import 'package:voicepocket/services/text_service.dart';

class CreateModelScreen extends StatefulWidget {
  const CreateModelScreen({super.key});

  @override
  State<CreateModelScreen> createState() => _CreateModelScreenState();
}

class _CreateModelScreenState extends State<CreateModelScreen> {
  final TextEditingController _textController = TextEditingController();
  late Future<TextModel> _futureText;
  String name = "";

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        name = _textController.text;
      });
    });
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
              ),
              Gaps.v48,
              CupertinoButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => postText(name),
                child: const Text("POST"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
