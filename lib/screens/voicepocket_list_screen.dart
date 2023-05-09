import 'package:flutter/material.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appbar',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appbar Icon Menu'),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('menu button is clicked');
          },
        ), //리딩속성은 간단한 위젯이나 아이콘들을 왼쪽에 위치해 시킨다.
        actions: [
          //이곳에 한개 이상의 위젯들을 가진다.
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              print('search button is clicked');
            },
          )
        ],
      ),
    );
  }
}