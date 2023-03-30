import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/recordroom/recordroom_main_screen.dart';

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

enum RecordingState {
  unready,
  ready,
  recording,
  stopped,
}

class RecordroomStudioScreen extends StatefulWidget {
  const RecordroomStudioScreen({Key? key}) : super(key: key);

  @override
  State<RecordroomStudioScreen> createState() => _RecordroomStudioScreenState();
}

class _RecordroomStudioScreenState extends State<RecordroomStudioScreen> {
  late Directory routeDir;
  int seconds = 0, minutes = 0;
  String digitSeconds = "00", digitMinutes = "00";

  IconData _recordIcon = FontAwesomeIcons.microphone;
  String _recordText = 'Click To Start';
  RecordingState _recordingState = RecordingState.unready;
  late FlutterAudioRecorder2 audioRecorder;

  int _index = 1;
  final int _maxLine = sentences.length;
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    FlutterAudioRecorder2.hasPermissions.then((hasPermision) {
      if (hasPermision!) {
        _recordingState = RecordingState.ready;
        _recordIcon = FontAwesomeIcons.microphoneSlash;
        _recordText = 'Record';
      }
    });
    createModelFolder().then((dir) => routeDir = dir);
  }

  void toNextPage() {
    setState(() {
      _index = _index + 1;
    });
  }

  Future<Directory> createModelFolder() async {
    final routeDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${routeDir.path}/model');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir;
    } else {
      dir.create();
      return dir;
    }
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.ready:
        await _recordVoice();
        break;

      case RecordingState.recording:
        await _stopRecording();
        _recordingState = RecordingState.stopped;
        _recordIcon = FontAwesomeIcons.solidCircle;
        _recordText = 'Record new one';
        break;

      case RecordingState.stopped:
        await _recordVoice();
        break;

      case RecordingState.unready:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  void zipEncoder(Directory dir, String zipPath) {
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(dir, filename: zipPath);
  }

  _initRecorder() async {
    String filePath =
        "${routeDir.path}/${DateTime.now().millisecondsSinceEpoch}.wav";
    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.WAV);
    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    await audioRecorder.stop();
  }

  Future<void> _recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();

      await _startRecording();
      _recordingState = RecordingState.recording;
      _recordIcon = FontAwesomeIcons.stop;
      _recordText = 'Recording';
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please allow recording from settings.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _recordingState = RecordingState.unready;
    super.dispose();
  }

  void completeModelCreate(BuildContext context) {
    zipEncoder(routeDir, "${routeDir.path}/psg1478795@naver.zip");
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
              Text(
                "00:00",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: Sizes.size32,
                  fontWeight: FontWeight.bold,
                ),
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
                            onPressed: () {},
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
                  await _onRecordButtonPressed();
                  setState(() {});
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    _recordIcon,
                    size: Sizes.size64,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_recordText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
