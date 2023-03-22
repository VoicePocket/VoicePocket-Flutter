import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/recordroom/recordroom_main_screen.dart';
import 'package:voicepocket/screens/voicepocket/media_player_screen.dart';

const sentences = [
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
];

class RecordroomStudioScreen extends StatefulWidget {
  const RecordroomStudioScreen({Key? key}) : super(key: key);

  @override
  State<RecordroomStudioScreen> createState() => _RecordroomStudioScreenState();
}

class _RecordroomStudioScreenState extends State<RecordroomStudioScreen> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  int _index = 1;
  final int _maxLine = sentences.length;
  double _value = 0.0;
  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "Microphone permission not granted";
    }
    recorder.openRecorder();
    isRecorderReady = true;
    await recorder.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
  }

  Future _startRecording() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(
      toFile: "audioFile_${DateTime.now().millisecondsSinceEpoch}.aac",
    );
  }

  Future _stopRecording() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print(audioFile);
  }

  void toNextPage() {
    setState(() {
      _index = _index + 1;
    });
  }

  void completeModelCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RecordroomMainScreen(),
      ),
    );
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
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size20,
          horizontal: Sizes.size20,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size8,
                    horizontal: Sizes.size28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0.5,
                        blurRadius: 5,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(Sizes.size16),
                    shape: BoxShape.rectangle,
                  ),
                  child: Text(
                    "$_index/$_maxLine",
                    style: const TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Gaps.v32,
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.33,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 223, 217, 253),
                      Color.fromARGB(255, 207, 198, 252),
                      Color.fromARGB(255, 196, 186, 247),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      offset: Offset(3, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(Sizes.size24),
                  shape: BoxShape.rectangle,
                ),
                child: Center(
                  child: Text(
                    sentences.elementAt(_index - 1),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: Sizes.size44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Gaps.v20,
              StreamBuilder<RecordingDisposition>(
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, '0');

                  final twoDigitMinutes =
                      twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                      twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: Sizes.size32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                stream: recorder.onProgress,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Slider(
                      activeColor: Theme.of(context).primaryColor,
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    Gaps.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size28,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Sizes.size32),
                            shape: BoxShape.rectangle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(10),
                            onPressed: () => (""),
                            icon: Image.asset(
                              "assets/images/return.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Gaps.h10,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size28,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(Sizes.size32),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(10),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const MediaPlayerScreen(
                                    path: "",
                                  ),
                                ),
                              );
                            },
                            icon: Image.asset(
                              "assets/images/play-button-arrowhead.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Gaps.h10,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size28,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(Sizes.size32),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(10),
                            onPressed: () => _index == _maxLine
                                ? completeModelCreate(context)
                                : toNextPage(),
                            icon: Image.asset(
                              _index == _maxLine
                                  ? "assets/images/random.png"
                                  : "assets/images/forward-button.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gaps.v36,
              FloatingActionButton.large(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (recorder.isRecording) {
                    await _stopRecording();
                  } else {
                    await _startRecording();
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    recorder.isRecording
                        ? FontAwesomeIcons.stop
                        : FontAwesomeIcons.microphone,
                    size: Sizes.size64,
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
