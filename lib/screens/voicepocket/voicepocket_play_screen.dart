//레이아웃 고치고 있는 페이지

import 'dart:async';
import '../authentications/home_screen.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class VoicePocketPlayScreen extends StatefulWidget {
  final String email;
  const VoicePocketPlayScreen({super.key, required this.email});

  @override
  State<VoicePocketPlayScreen> createState() => _VoicePocketPlayScreenState();
}

int recent_song = 0;
int past_song = -1;
int total_song = 0;
int LoopNum = 0;

List? songs2 = [];

bool isLoop = false;


class _VoicePocketPlayScreenState extends State<VoicePocketPlayScreen> {

  @override
  void initState() {
    super.initState();
  
  }

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
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
      body: Column(
        children: [
          Text('test')
        ],
      ),
    );
  }
}

Future<List<String>> loadingSongs2(String email) async {
  List<String> mp3FileNames = [];

  Directory appDocDir = await getApplicationDocumentsDirectory();

  String DocDir1 = appDocDir.path;
  String DocDir2 = '$DocDir1/wav/$email';

  List files = Directory(DocDir2).listSync();

  for (FileSystemEntity file in files) {
    String filePath = (file.path);
    if (filePath.endsWith('.wav')) {
      mp3FileNames.add(filePath.split('/').last);
    }
  }
  return mp3FileNames;
}

Future<String> loadingSongs(String email) async {
  List<String> mp3FileNames = [];

  Directory appDocDir = await getApplicationDocumentsDirectory();

  String DocDir1 = appDocDir.path;
  String DocDir2 = '$DocDir1/wav/$email';

  List files = Directory(DocDir2).listSync();

  print("loadingSongs $files");

  for (FileSystemEntity file in files) {
    String filePath = (file.path);
    if (filePath.endsWith('.wav')) {
      mp3FileNames.add(filePath.split('/').last);
    }
  }

  print(mp3FileNames);
  //print(appDocDir.path);
  songs2 = mp3FileNames;
  if (mp3FileNames.isEmpty) {
    return '';
  } else {
    var songname = mp3FileNames[recent_song];
    var file = File("${appDocDir.path}/wav/$email/$songname");

    return file.path;
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                thumbColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
