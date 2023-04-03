import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class VoicePocketPlayScreen extends StatefulWidget {
  const VoicePocketPlayScreen({super.key});

  @override
  State<VoicePocketPlayScreen> createState() => _VoicePocketPlayScreenState();
} 

class PositionData{
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class Controls extends StatelessWidget{
  const Controls({
    super.key,
    required this.audioPlayer,
    });

    final AudioPlayer audioPlayer;

    @override
    Widget build(BuildContext context){
      return StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          
          if(!(playing??false)){
            return IconButton(
              onPressed: audioPlayer.play,
              iconSize: 40,
              color: Theme.of(context).primaryColor,
              icon: const Icon(Icons.play_arrow_rounded),
            );
          }else if(processingState != ProcessingState.completed){
            return IconButton(
              onPressed: audioPlayer.pause,
              iconSize: 40,
              color: Theme.of(context).primaryColor,
              icon: const Icon(Icons.pause_rounded),
            );
          }
          return const Icon(
            Icons.play_arrow_rounded,
            size: 40,
          );
        },
      );
    }
}

int recent_song = 0;
int past_song = -1;

class _VoicePocketPlayScreenState extends State<VoicePocketPlayScreen> {
  late AudioPlayer player; 

  @override
  void initState(){
    super.initState();
    player = AudioPlayer();
  }

  final int _current = 0;

  List? songs2 = [];

  bool isPlaying = false;

  Stream<PositionData> get _positionDataStream =>
    Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      player.positionStream,
      player.bufferedPositionStream,
      player.durationStream,
      (position, bufferedPosition, duration) => PositionData(
        position, 
        bufferedPosition, 
        duration ?? Duration.zero,
        ),
      );

  @override
  void dispose() {
    player.dispose();
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
      body: Column(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size40,
              horizontal: Sizes.size16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        FutureBuilder(
                        future: loadingSongs2(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if (snapshot.hasData == true){
                              return CarouselSlider.builder(
                                itemCount: snapshot.data.length, 
                                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                                  return Container(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Image.asset(
                                            'assets/images/playpage2.png',
                                            fit: BoxFit.cover,
                                            ),
                                        ),
                                        Text(snapshot.data?[itemIndex]),
                                  ],
                                )
                              );},
                              options: CarouselOptions(
                                height: MediaQuery.of(context).size.height * 0.46,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    player.stop();
                                    isPlaying = false;
                                    print(index.toString());
                                    recent_song = index;
                                  });
                                },
                              )
                              );
                            }
                            else{
                              return const Center(child: Text("no songs in assets"));
                            }
                          }
                          ),
                        
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                      FutureBuilder(
                        future: loadingSongs(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if (snapshot.hasData == false){
                            return const Center(child: Text("no songs in assets"));
                          }
                          else {
                            String songname = snapshot.data;
                            return Column(
                              children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                          padding: const EdgeInsets.all(20),
                                          onPressed: () => (""),
                                          icon: Image.asset(
                                            "assets/images/speaker.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        Text(recent_song.toString()),
                                        IconButton(
                                          padding: const EdgeInsets.all(20),
                                          onPressed: () => (""),
                                          icon: Image.asset(
                                            "assets/images/playlist.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                    StreamBuilder<PositionData>(
                                      stream: _positionDataStream,
                                      builder: (context, snapshot){
                                        final positionData = snapshot.data;
                                        return ProgressBar(
                                          barHeight: 4,
                                          progressBarColor: Theme.of(context).primaryColor,
                                          thumbColor: Theme.of(context).primaryColor,
                                          progress: positionData?.position ?? Duration.zero, 
                                          buffered: positionData?.bufferedPosition ?? Duration.zero,
                                          total: positionData?. duration ?? Duration.zero,
                                          onSeek: player.seek,
                                        );
                                      },
                                      ),
                                      const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: () => (""),
                                      icon: Image.asset(
                                        "assets/images/return.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: () => (""),
                                      icon: Image.asset(
                                        "assets/images/back-button.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    StreamBuilder<PlayerState>(
                                      stream: player.playerStateStream,
                                      builder: (context, snapshot) {
                                        final playerState = snapshot.data;
                                        final processingState = playerState?.processingState;
                                        final playing = playerState?.playing;

                                        if(!(playing??false)){
                                          return IconButton(
                                            onPressed: () async {
                                              if (recent_song != past_song){
                                                await player.setFilePath(songname);
                                                past_song = recent_song;
                                                player.play();
                                              }
                                              else{
                                                player.play();
                                              }
                                            } ,
                                            iconSize: 40,
                                            color: Theme.of(context).primaryColor,
                                            icon: const Icon(Icons.play_arrow_rounded),
                                          );
                                        }else if(processingState != ProcessingState.completed){
                                          return IconButton(
                                            onPressed: player.pause,
                                            iconSize: 40,
                                            color: Theme.of(context).primaryColor,
                                            icon: const Icon(Icons.pause_rounded),
                                          );
                                        }
                                        return const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 40,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: () => (""),
                                      icon: Image.asset(
                                        "assets/images/forward-button.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: () => (""),
                                      icon: Image.asset(
                                        "assets/images/random.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ] 
                            );
                          }
                        },
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

Future<String> loadingSongs() async {
  late AudioPlayer player; 

  final directory = await getApplicationDocumentsDirectory();                                    

  List<String> fileNames = [];

  if (await directory.exists()) {
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        String fileName = file.path.split('/').last;
        String extension = fileName.split('.').last;
        if (extension == 'mp3') {
          fileNames.add(fileName);
        }
      }
    }
  }
  
  var songname = fileNames[recent_song];
  var file = File("${directory.path}/$songname"); 

  return file.path;
}

Future<List<String>> loadingSongs2() async {
  late AudioPlayer player; 

  final directory = await getApplicationDocumentsDirectory();                                    

  List<String> fileNames = [];

  if (await directory.exists()) {
    List<FileSystemEntity> files = directory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        String fileName = file.path.split('/').last;
        String extension = fileName.split('.').last;
        if (extension == 'mp3') {
          fileNames.add(fileName);
        }
      }
    }
  }

  print(fileNames);

  return fileNames;
}