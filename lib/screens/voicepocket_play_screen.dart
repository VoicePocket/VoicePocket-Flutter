import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/create_model.dart';
import 'package:carousel_slider/carousel_slider.dart';


class VoicePocketPlayScreen extends StatelessWidget {
  VoicePocketPlayScreen({super.key});

  void _onCreateModelTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreateModelScreen()),
    );
  }

  final CarouselController _controller = CarouselController();

  List _isHovering = [false, false, false, false, false, false, false];
  List _isSelected = [true, false, false, false, false, false, false];

  int _current = 0;

  final List<String> images = [
    'images/playwidget.png',
    'images/playwidget.png',
    'images/playwidget.png',
    'images/playwidget.png',
    'images/playwidget.png',
    'images/playwidget.png',
    'images/playwidget.png',
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
        fit:BoxFit.cover,
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size40,
              horizontal: Sizes.size16,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  child: Stack(
                    children: [
                      CarouselSlider(items: generateImagesTiles(), options: CarouselOptions(
                        enlargeCenterPage: true,
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onPressed: () => _onCreateModelTab(context),
          child: const Icon(
            Icons.add_circle_outline_outlined,
            size: Sizes.size44,
          ),
        ),
      ),
    );
  }
}
