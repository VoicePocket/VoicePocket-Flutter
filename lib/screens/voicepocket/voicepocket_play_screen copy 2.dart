import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
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

class _VoicePocketPlayScreenState extends State<VoicePocketPlayScreen> {
  
  final player = AudioPlayer(audioLoadConfiguration: AudioLoadConfiguration( androidLoadControl: AndroidLoadControl( prioritizeTimeOverSizeThresholds: true ))); 

  final int _current = 0;

  int recent_song = 0;
  List? songs2 = [];

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

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
                        FutureBuilder<String>(
                          future: DefaultAssetBundle.of(context).loadString('AssetManifest.json'),
                          builder: (context, item){
                            if(item.hasData){
                              Map? jsonMap = json.decode(item.data!);
                              List? songs = jsonMap?.keys.where((element) => element.contains('.mp3')).toList();
                              return CarouselSlider.builder(
                                itemCount: songs?.length, 
                                //itemCount: places.length,
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
                                        Text(songs?[itemIndex]),
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
                    child: Column(children: [
                      FutureBuilder(
                      future: DefaultAssetBundle.of(context).loadString('AssetManifest.json'),
                          builder: (context, item){
                            if(item.hasData){
                              Map? jsonMap = json.decode(item.data!);
                              List? songs2 = jsonMap?.keys.where((element) => element.contains('.mp3')).toList();
                              return Container(
                                child: Column(
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
                                  //Text(songs2![recent_song]),
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
                              Slider(
                                  activeColor: Theme.of(context).primaryColor,
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  value: position.inSeconds.toDouble(),
                                  onChanged: (value) async {
                                    final position = Duration(seconds: value.toInt());
                                    await player.seek(position);

                                    await player.play();
                                  },),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.size16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(formatTime(position)),
                                        Text(formatTime(duration)),
                                      ],
                                    ),
                                  ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
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
                                  IconButton(
                                    padding: const EdgeInsets.all(20),
                                    onPressed: () async {
                                      var content = await rootBundle.load(songs2![recent_song]);
                                      int findslash = songs2[recent_song].lastIndexOf('/');
                                      String songname = songs2[recent_song].substring(findslash);
                                      print(songname);

                                      final directory = await getApplicationDocumentsDirectory();
                                      var file = File("${directory.path}$songname");                                        
                                      file.writeAsBytesSync(content.buffer.asUint8List());
                                      print(file.path);
                                      await player.setFilePath(file.path);

                                      setState(() {
                                        if (isPlaying) {
                                        player.stop();
                                        print(isPlaying);
                                        isPlaying = false;
                                      }
                                      else {
                                        player.play();
                                        print(isPlaying);
                                        isPlaying = true;
                                      }
                                      });
                                    },
                                    icon: Icon(
                                      isPlaying ? Icons.pause : Icons.play_arrow,
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      iconSize: Sizes.size40,
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
                                  ],)
                              );
                            }
                      else{
                              return const Center(child: Text("no songs in assets"));
                            };})
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

