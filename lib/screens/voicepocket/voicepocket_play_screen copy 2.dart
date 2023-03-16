import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:voicepocket/constants/sizes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voicepocket/screens/voicepocket/post_text_screen.dart';
import 'dart:io' as io;

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

  final CarouselController _controller = CarouselController();

  final List _isHovering = [false, false, false, false, false, false, false];

  final List _isSelected = [true, false, false, false, false, false, false];

  final int _current = 0;
  

  List<String> alone = [];

  double _value = 0.0;

  final List<String> images = [
    'assets/images/Frame2.png',
  ];

  final List<String> places = [
    'ASIA',
    'AFRICA',
    'EUROPE',
    'SOUTH AMERICA',
    'AUSTRALIA',
    'ANTARCTICA',
  ];

  loadPathSounds(BuildContext context) async {
    List<String> listaAssetsFiltered = [];

    //var directory = (await getApplicationDocumentsDirectory()).path;

    // Load as String
    final manifestContent =
      //await rootBundle.loadString('assets/AssetManifest.json');
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    // Decode to Map
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter
    //final List<String> listMp3 = manifestMap.keys.where((String key) => key.contains('.mp3')).toList();

    final listMp3 = manifestMap.keys
      .where((String key) => key.contains('song/'))
      .where((String key) => key.contains('.mp3'))
      .toList();

    //for (String mp3 in listMp3){
      //listaAssetsFiltered.add(mp3);
    //}

    setState((){
      alone = listMp3;
      //alone = io.Directory("$directory").listSync();
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
                                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                  Container(
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
                                        Text(songs?[itemIndex])
                                        //Text(alone[itemIndex])
                                  ],
                                )
                              ),
                              options: CarouselOptions(
                                height: MediaQuery.of(context).size.height * 0.58,
                                enlargeCenterPage: true,
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
                            onPressed: () => (""),
                            icon: Image.asset(
                              "assets/images/play-button-arrowhead.png",
                              width: 40,
                              height: 40,
                            ),
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
