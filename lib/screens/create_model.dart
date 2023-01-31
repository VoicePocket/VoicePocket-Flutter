import 'package:flutter/material.dart';

class CreateModelScreen extends StatefulWidget {
  const CreateModelScreen({super.key});

  @override
  State<CreateModelScreen> createState() => _CreateModelScreenState();
}

class _CreateModelScreenState extends State<CreateModelScreen> {
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
    );
  }
}
