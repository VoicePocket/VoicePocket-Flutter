import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:voicepocket/constants/sizes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voicepocket/screens/voicepocket/post_text_screen.dart';
import 'dart:io';

class VoicePocketPlayScreen extends StatefulWidget {
  const VoicePocketPlayScreen({super.key});

  @override
  State<VoicePocketPlayScreen> createState() => _VoicePocketPlayScreenState();
} 

class _VoicePocketPlayScreenState extends State<VoicePocketPlayScreen> {
  void _onCreateModelTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PostTextScreen()),
    );
  }
  
  final player = AudioPlayer(); 

  final int _current = 0;

  int recent_song = 0;
  List? songs2 = [];

  double _value = 0.0;

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
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
                                height: MediaQuery.of(context).size.height * 0.58,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
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
                                  value: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  }),
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
                                      if (isPlaying) {
                                        await player.pause();
                                      }
                                      else {
                                        await player.play(UrlSource(songs2![recent_song]));
                                      }
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
