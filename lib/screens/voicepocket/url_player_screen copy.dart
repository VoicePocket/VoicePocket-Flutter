import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHelper {
  final AudioPlayer audioPlayer = AudioPlayer();
  final ValueNotifier<Duration> durationNotifier = ValueNotifier(Duration.zero);
  Stream<PlayerState> get playerStateStream => audioPlayer.onPlayerStateChanged;
  final ValueNotifier<bool> isIdleNotifier = ValueNotifier(true);

  AudioPlayerHelper() {
    audioPlayer.onDurationChanged.listen((duration) {
      if (duration != null) {
        durationNotifier.value = duration;
      }
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped ||
          state == PlayerState.completed ||
          state == PlayerState.paused) {
        isIdleNotifier.value = true;
      } else {
        isIdleNotifier.value = false;
      }
    });
  }

  Future<void> playAudio(String audioUrl) async {
    await audioPlayer.setSourceUrl(audioUrl);
    await audioPlayer.resume();
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }

  void dispose() {
    audioPlayer.dispose();
    durationNotifier.dispose();
    isIdleNotifier.dispose();
  }
}

class AudioPlayerPage extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;

  const AudioPlayerPage({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
  }) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final audioPlayerHelper = AudioPlayerHelper();
  bool isPlaying = false;

  @override
  void dispose() {
    audioPlayerHelper.dispose();
    super.dispose();
  }

  void toggleAudioPlayback() {
    if (isPlaying) {
      audioPlayerHelper.pauseAudio();
    } else {
      audioPlayerHelper.playAudio(widget.message);
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _audio(message: widget.message, isCurrentUser: widget.sentByMe))
      ],
    );
  }

  Widget _audio({
    required String message,
    required bool isCurrentUser,
  }) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color.fromRGBO(243, 230, 255, 0.816) : Colors.grey[600],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              toggleAudioPlayback();
            },
            child: StreamBuilder<PlayerState>(
              stream: audioPlayerHelper.playerStateStream,
              initialData: PlayerState.stopped,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data == PlayerState.playing;
                return Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: isCurrentUser ? Colors.white : Colors.white,
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  StreamBuilder<PlayerState>(
                      stream: audioPlayerHelper.playerStateStream,
                      builder: (context, snapshot) {
                        final isIdle = snapshot.data == PlayerState.stopped;
                        return LinearProgressIndicator(
                          minHeight: 5,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCurrentUser ? Colors.white : Colors.white,
                          ),
                          value: isPlaying && !isIdle ? null : 0.0,
                        );
                      },
                    ),
                  ValueListenableBuilder<Duration>(
                    valueListenable: audioPlayerHelper.durationNotifier,
                    builder: (context, duration, _) {
                      final isIdle = audioPlayerHelper.isIdleNotifier.value;
                      return Positioned.fill(
                        child: Center(
                          child: Text(
                            isIdle ? duration.toString() : audioPlayerHelper.audioPlayer.getCurrentPosition().toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isCurrentUser ? Colors.white : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
