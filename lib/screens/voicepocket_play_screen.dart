import 'package:flutter/material.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/create_model.dart';
import 'package:carousel_slider/carousel_slider.dart';


class VoicePocketPlayScreen extends StatefulWidget {
  VoicePocketPlayScreen({super.key});

  @override
  State<VoicePocketPlayScreen> createState() => _VoicePocketPlayScreenState();
}

class _VoicePocketPlayScreenState extends State<VoicePocketPlayScreen> {
  void _onCreateModelTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreateModelScreen()),
    );
  }

  final CarouselController _controller = CarouselController();

  List _isHovering = [false, false, false, false, false, false, false];

  List _isSelected = [true, false, false, false, false, false, false];

  int _current = 0;

  double _value = 0.0;

  final List<String> images = [
    'assets/images/playpage.png',
    'assets/images/playpage.png',
    'assets/images/playpage.png',
    'assets/images/playpage.png',
    'assets/images/playpage.png',
    'assets/images/playpage.png',
    'assets/images/playpage.png',
  ];

  final List<String> places = [
    'ASIA',
    'AFRICA',
    'EUROPE',
    'SOUTH AMERICA',
    'AUSTRALIA',
    'ANTARCTICA',
  ];

  List<Widget> generateImagesTiles(){
    return images.map((element)=>ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.asset(element,
        fit:BoxFit.none,
      ),
    )).toList();
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
      body: Column(
        children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size40,
              horizontal: Sizes.size16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible( //Carousel slider 크기 조절 부분
                  //fit: FlexFit.tight,
                  //flex:6,
                  child: Container(                     
                    alignment: Alignment.topCenter,             
                    //padding: const EdgeInsets.only(top: 50),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        CarouselSlider(items: generateImagesTiles(), options: CarouselOptions(
                          enlargeCenterPage: true,
                        )),
                      ],
                    ),
                  ),
                ),
                Flexible( //재생관련 부분 크기 조절 
                  //fit: FlexFit.tight,
                  //flex: 3,
                  child: Container(                            
                    alignment: Alignment.bottomCenter,      
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              padding: EdgeInsets.all(20),
                              onPressed: ()=> (""),
                              icon: Image.asset(
                                "assets/images/speaker.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(20),
                              onPressed: ()=> (""),
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
                                _value=value;
                              });
                            }
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              padding: EdgeInsets.all(20),
                              onPressed: ()=> (""),
                              icon: Image.asset(
                                "assets/images/return.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(20),
                              onPressed: ()=> (""),
                              icon: Image.asset(
                                "assets/images/back-button.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(20),
                              onPressed: ()=> (""),
                              icon: Image.asset(
                                "assets/images/play-button-arrowhead.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(20),
                              onPressed: ()=> (""),
                              icon: Image.asset(
                                "assets/images/forward-button.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(20),
                              onPressed: ()=> (""),
                              icon: Image.asset(
                                "assets/images/random.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ]
      ),
    );
  }
}
