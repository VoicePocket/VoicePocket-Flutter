//현재 사용 중인 페이지

import 'dart:async';
import 'package:voicepocket/services/google_cloud_service.dart';
import 'package:voicepocket/services/song_progressbar.dart';
import '../authentications/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

class VoicePocketPlayScreenCopy extends StatefulWidget {
  final String email;
  const VoicePocketPlayScreenCopy({super.key, required this.email});

  @override
  State<VoicePocketPlayScreenCopy> createState() =>
      _VoicePocketPlayScreenCopyState();
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  get processingState => null;
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (!(playing ?? false)) {
          return IconButton(
            onPressed: audioPlayer.play,
            iconSize: 40,
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.play_arrow_rounded),
          );
        } else if (processingState != ProcessingState.completed) {
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
int total_song = 0;
int LoopNum = 0;

List? songs2 = [];

bool isLoop = false;

class _VoicePocketPlayScreenCopyState extends State<VoicePocketPlayScreenCopy> {
  late AudioPlayer player;
  final CarouselController _carouselController = CarouselController();
  LoopMode _loopMode = LoopMode.off;
  late final StreamSubscription<PlayerState> _playerStateSubscription =
      player.playerStateStream.listen((PlayerState playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      if (_loopMode == LoopMode.all) {
        _playNext();
      }
    }
  });

  @override
  void initState() {
    super.initState();
    recent_song = 0;
    past_song = -1;
    print("initState");
    player = AudioPlayer();
    //player.setLoopMode(_loopMode);
    print("initState2");
  }

  void toHomeScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  /* void _handlePreviousButtonPressed() async {
    await player.seekToPrevious();
    final int newIndex = recent_song - 1;
    _carouselController.animateToPage(newIndex);
  }

  void _handleNextButtonPressed() async {
    await player.seekToNext();
    final int newIndex = recent_song + 1;
    _carouselController.animateToPage(newIndex);
  } */

  void _handlePreviousButtonPressed() async {
    await player.seekToPrevious();
    final int newIndex = recent_song - 1;
    _carouselController.animateToPage(newIndex);
    _positionDataStream.listen((positionData) {
      (PositionData(
        Duration.zero,
        positionData.bufferedPosition,
        positionData.duration,
      ));
    });
    print('포지션 변경');
  }

  void _handleNextButtonPressed() async {
    await player.seekToNext();
    final int newIndex = recent_song + 1;
    _carouselController.animateToPage(newIndex);
    _positionDataStream.any(
        const PositionData(Duration.zero, Duration.zero, Duration.zero) as bool
            Function(PositionData element));
  }

  void _handleLoopButtonPressed() {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.one;
        print('one');
        break;
      case LoopMode.one:
        _loopMode = LoopMode.all;
        print('all');
        print(_loopMode);
        break;
      case LoopMode.all:
        _loopMode = LoopMode.off;
        print('off');
        break;
    }
    player.setLoopMode(_loopMode);
    setState(() {});
  }

  Future<void> _playNext() async {
    print("recent_song $recent_song");
    int nextIndex = recent_song + 1;
    if (nextIndex >= total_song) {
      nextIndex = 0;
    }
    print("nextIndex $nextIndex");

    _carouselController.animateToPage(nextIndex);

    await player.seek(Duration.zero);
    await player.play();
  }

  IconData get _loopIcon {
    switch (_loopMode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return FontAwesomeIcons.repeat;
    }
  }

  final int _current = 0;
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
    _playerStateSubscription.cancel();
    print("dispose");
    //player.dispose();
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
      body: Column(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: Sizes.size20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.58,
                    alignment: Alignment.topCenter,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        FutureBuilder(
                            future: loadingSongs2(widget.email),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == true) {
                                if (snapshot.data.isEmpty) {
                                  return const Center(
                                      child: Text("no songs in assets"));
                                } else {
                                  return CarouselSlider.builder(
                                      carouselController: _carouselController,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context,
                                          int itemIndex, int pageViewIndex) {
                                        return Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          offset: const Offset(
                                                              -3, 0),
                                                          blurRadius: 8.0,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.15),
                                                        )
                                                      ],
                                                      gradient:
                                                          const LinearGradient(
                                                              colors: [
                                                            Color(0xFFCDC1FF),
                                                            Color(0xFFE5D9F2)
                                                          ],
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight)),
                                                ),
                                                Text(
                                                  snapshot.data?[itemIndex],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ));
                                      },
                                      options: CarouselOptions(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.58,
                                        enlargeCenterPage: true,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            player.stop();
                                            const PositionData(Duration.zero,
                                                Duration.zero, Duration.zero);
                                            isPlaying = false;
                                            print(index.toString());
                                            recent_song = index;
                                            total_song = snapshot.data.length;
                                          });
                                        },
                                      ));
                                }
                              } else {
                                return const Center(
                                    child: Text("no songs in assets"));
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(children: [
                      FutureBuilder(
                        future: loadingSongs(widget.email),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData == false) {
                            return const Center(
                                child: Text("no songs in assets"));
                          } else {
                            if (snapshot.data.isEmpty) {
                              return const Center(
                                  child: Text("no songs in assets"));
                            } else {
                              String songname = snapshot.data;
                              return Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: () {
                                        showSliderDialog(
                                          context: context,
                                          title: "Volume Control",
                                          divisions: 10,
                                          min: 0.0,
                                          max: 1.0,
                                          value: player.volume,
                                          stream: player.volumeStream,
                                          onChanged: player.setVolume,
                                        );
                                      },
                                      icon: Image.asset(
                                        "assets/images/speaker.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    Text(recent_song.toString()),
                                    IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: () {},
                                      icon: Image.asset(
                                        "assets/images/playlist.png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ],
                                ),
                                /* StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return SongProgressBar(
                                      barHeight: 4,
                                      progressBarColor:
                                          Theme.of(context).primaryColor,
                                      thumbColor:
                                          Theme.of(context).primaryColor,
                                      progress: positionData?.position ??
                                          Duration.zero,
                                      buffered:
                                          positionData?.bufferedPosition ??
                                              Duration.zero,
                                      total: positionData?.duration ??
                                          Duration.zero,
                                      onSeek: player.seek,
                                    );
                                  },
                                ), */
                                StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data ??
                                        const PositionData(
                                          Duration.zero,
                                          Duration.zero,
                                          Duration.zero,
                                        );
                                    return SongProgressBar(
                                      barHeight: 4,
                                      progressBarColor:
                                          Theme.of(context).primaryColor,
                                      thumbColor:
                                          Theme.of(context).primaryColor,
                                      progress: positionData.position,
                                      buffered: positionData.bufferedPosition,
                                      total: positionData.duration,
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
                                      //use LoopNum
                                      onPressed: _handleLoopButtonPressed,
                                      icon: Icon(
                                        _loopIcon,
                                        size: 30,
                                      ),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: _handlePreviousButtonPressed,
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
                                        final processingState =
                                            playerState?.processingState;
                                        final playing = playerState?.playing;

                                        if (!(playing ?? false)) {
                                          return IconButton(
                                            onPressed: () async {
                                              if (recent_song != past_song) {
                                                await player
                                                    .setFilePath(songname);
                                                past_song = recent_song;
                                                player.play();
                                              } else {
                                                player.play();
                                              }
                                            },
                                            iconSize: 40,
                                            color:
                                                Theme.of(context).primaryColor,
                                            icon: const Icon(
                                                Icons.play_arrow_rounded),
                                          );
                                        } else if (processingState !=
                                            ProcessingState.completed) {
                                          return IconButton(
                                            onPressed: player.pause,
                                            iconSize: 40,
                                            color:
                                                Theme.of(context).primaryColor,
                                            icon:
                                                const Icon(Icons.pause_rounded),
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
                                      onPressed: _handleNextButtonPressed,
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
                              ]);
                            }
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

Future<List<String>> loadingSongs2(String email) async {
  List<String> mp3FileNames = [];

  Directory appDocDir = await getPublicDownloadFolderPath();

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

  //List<FileSystemEntity> files = appDocDir.listSync();

  String DocDir1 = appDocDir.path;
  String DocDir2 = '$DocDir1/wav/$email';

  List files = Directory(DocDir2).listSync();

  print("loadingSongs $files");

  for (FileSystemEntity file in files) {
    String filePath = (file.path);
    //String filePath2 = '$filePath';
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
