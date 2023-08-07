import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/voicepocket/url_player_screen.dart';
import 'package:voicepocket/services/google_cloud_service.dart';

class MessageTile extends StatefulWidget {
  final String wavUrl;
  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.wavUrl,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool isUrlMessage = false;
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();
    checkIfUrlMessage();
  }

  void checkIfUrlMessage() {
    if (widget.message.startsWith('https')) {
      setState(() {
        isUrlMessage = true;
      });
    }
  }

  Future<void> downloadTap(String wavUrl) async {
    await readWavFile(wavUrl);
    setState(() {
      isDownloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 12,
        right: widget.sentByMe ? 12 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 60)
            : const EdgeInsets.only(right: 60),
        padding: const EdgeInsets.only(
          top: 17,
          bottom: 17,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: widget.sentByMe
              ? Theme.of(context).primaryColor
              : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (isUrlMessage)
              Column(
                children: [
                  SizedBox(
                    height: 50, // 적절한 크기를 지정하세요.
                    child: AudioPlayerPage(
                        message: widget.message,
                        sender: widget.sender,
                        sentByMe: widget.sentByMe),
                  ),
                  Gaps.v10,
                  GestureDetector(
                    onTap: () async => downloadTap(widget.wavUrl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDownloaded ? Colors.grey.shade700 : Colors.white,
                        borderRadius: BorderRadius.circular(Sizes.size10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "DOWNLOAD",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: Sizes.size16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                widget.message,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
