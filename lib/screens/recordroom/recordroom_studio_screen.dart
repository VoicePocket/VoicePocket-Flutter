import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/screens/recordroom/recordroom_main_screen.dart';
import 'package:voicepocket/services/load_csv.dart';

import '../../services/google_cloud_service.dart';

enum RecordingState {
  unready,
  ready,
  recording,
  stopped,
}

class RecordroomStudioScreen extends StatefulWidget {
  final Map<String, List<String>> metaData;
  const RecordroomStudioScreen({super.key, required this.metaData});

  @override
  State<RecordroomStudioScreen> createState() => _RecordroomStudioScreenState();
}

class _RecordroomStudioScreenState extends State<RecordroomStudioScreen> {
  bool _hasPermission = false;
  List<String> name = [], content = [];
  Directory modelDir = Directory("");
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  IconData _recordIcon = FontAwesomeIcons.microphoneSlash;
  String _recordText = '권한 없음';
  TextStyle _recordTextStyle = TextStyle(
    fontSize: Sizes.size20,
    color: Colors.grey.shade700,
    fontWeight: FontWeight.w900,
  );
  RecordingState _recordingState = RecordingState.unready;
  late FlutterAudioRecorder2 audioRecorder;

  int _index = 1;
  final int _maxLine = 315;

  @override
  void initState() {
    super.initState();
    requestPermission();
    getPublicDownloadFolderPath().then((dir) {
      modelDir = Directory("${dir.path}/model");
    });
    loadList();
  }

  Future<void> requestPermission() async {
    _hasPermission = await Permission.microphone.request().isGranted;
    if (_hasPermission) {
      setState(() {
        _recordingState = RecordingState.ready;
        _recordIcon = FontAwesomeIcons.microphone;
        _recordText = '녹음 준비 완료';
      });
    }
  }

  void toNextPage() async {
    String filePath =
        "${modelDir.path}/${widget.metaData['name']![_index - 1]}.wav";
    if (_recordingState == RecordingState.recording) {
      await _stopRecording();
    }
    if (!await File(filePath).exists()) {
      return;
    }
    _index = _index + 1;
    setState(() {});
  }

  void toPreviousPage() async {
    if (_recordingState == RecordingState.recording) {
      await _stopRecording();
    }
    if (_index != 1) {
      _index = _index - 1;
    }
    setState(() {});
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.ready:
        await _recordVoice();
        break;

      case RecordingState.recording:
        await _stopRecording();
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
    setState(() {});
  }

  _initRecorder() async {
    String filePath =
        "${modelDir.path}/${widget.metaData['name']![_index - 1]}.wav";
    if (await File(filePath).exists()) {
      await File(filePath).delete();
    }
    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.WAV);
    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    final file = await audioRecorder.stop();
    _recordingState = RecordingState.stopped;
    _recordIcon = FontAwesomeIcons.solidCircle;
    _recordText = '녹음하기';
    _recordTextStyle = TextStyle(
      fontSize: Sizes.size20,
      fontWeight: FontWeight.w900,
      color: Colors.grey.shade700,
    );
    await setAudio(file!.path!);
  }

  Future<void> _recordVoice() async {
    await _initRecorder();
    await _startRecording();
    _recordingState = RecordingState.recording;
    _recordIcon = FontAwesomeIcons.stop;
    _recordText = '녹음중..';
    _recordTextStyle = const TextStyle(
      fontSize: Sizes.size20,
      fontWeight: FontWeight.w900,
      color: Colors.red,
    );
  }

  void zipEncoder(Directory dir, String zipPath) {
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(dir, filename: zipPath);
  }

  void completeModelCreate(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final email = pref.getString('email');
    zipEncoder(modelDir, "${modelDir.parent.path}/$email.zip");
    await uploadModelVoiceFileToBucket();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const RecordroomMainScreen(),
      ),
      (route) => false,
    );
  }

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> setAudio(String path) async {
    audioPlayer = AudioPlayer();
    await audioPlayer.setSourceDeviceFile(path);
    await audioPlayer.setReleaseMode(ReleaseMode.release);
    isPlaying = audioPlayer.state == PlayerState.playing;
    audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.completed:
          setState(() {
            isPlaying = !isPlaying;
          });
          break;
        default:
          break;
      }
    });
  }

  Future<void> mediaPlay() async {
    if (_recordingState == RecordingState.ready) return;
    if (isPlaying) {
      audioPlayer.pause();
      setState(() {
        isPlaying = !isPlaying;
      });
    } else {
      audioPlayer.resume();
      setState(() {
        isPlaying = !isPlaying;
      });
    }
    setState(() {});
  }

  loadList() async {
    final list = await loadCSV();
    name = list['name']!;
    content = list['content']!;
  }

  @override
  void dispose() {
    _recordingState = RecordingState.unready;
    super.dispose();
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
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade700,
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
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size20,
                ),
                child: Center(
                  child: Text(
                    widget.metaData["content"]![_index - 1],
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Gaps.v20,
              Gaps.v20,
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Gaps.h10,
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
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
                            onPressed: () {
                              if (_index == 0) return;
                              toPreviousPage();
                            },
                            icon: Image.asset(
                              "assets/images/back-button.png",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Gaps.h10,
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
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
                            onPressed: () async {
                              mediaPlay();
                              setState(() {});
                            },
                            icon: FaIcon(
                              isPlaying
                                  ? FontAwesomeIcons.pause
                                  : FontAwesomeIcons.play,
                              color: Theme.of(context).primaryColor,
                              size: Sizes.size32,
                            ),
                            // icon: Image.asset(
                            //   isPlaying
                            //       ? "assets/images/random.png"
                            //       : "assets/images/play-button-arrowhead.png",
                            //   width: 40,
                            //   height: 40,
                            // ),
                          ),
                        ),
                        Gaps.h10,
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
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
                child: Text(_recordText, style: _recordTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
