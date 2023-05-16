import 'package:flutter/material.dart';

class MessageTileIndicator extends StatefulWidget {

  const MessageTileIndicator(
      {Key? key})
      : super(key: key);

  @override
  State<MessageTileIndicator> createState() => _MessageTileIndicatorState();
}

class _MessageTileIndicatorState extends State<MessageTileIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: 12,),
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: Colors.grey[700]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SERVER",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5),
            ),
            CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 8.0,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}