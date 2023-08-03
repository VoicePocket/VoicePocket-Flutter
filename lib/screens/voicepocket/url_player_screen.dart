import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voicepocket/screens/voicepocket/voicepocket_play_screen copy.dart';

class AudioPlayerHelper {
  final AudioPlayer audioPlayer = AudioPlayer();
  final BehaviorSubject<PlayerState> _playerStateSubject = BehaviorSubject<PlayerState>();
  Stream<PlayerState> get playerStateStream => _playerStateSubject.stream;
  
  AudioPlayerHelper() {
    _init();
  }

  Future<void> _init() async {
    audioPlayer.playerStateStream.listen((playerState) {
      _playerStateSubject.add(playerState);
    });
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  double get completedPercentage {
    final duration = audioPlayer.duration?.inMilliseconds ?? 0;
    final position = audioPlayer.position.inMilliseconds;
    return duration > 0 ? position / duration : 0.0;
  }

  String get currentDuration {
    final position = audioPlayer.position.inSeconds;
    final minutes = (position ~/ 60).toString().padLeft(2, '0');
    final seconds = (position % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> playAudio(String audioUrl) async {
    await audioPlayer.setUrl(audioUrl);
    await audioPlayer.load(); 
    await audioPlayer.play();
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }

  void dispose() {
    //audioPlayer.dispose();
    //_playerStateSubject.close();
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
    //audioPlayerHelper.dispose();
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
        InkWell(
          onTap: () {
            if (isPlaying) {
              audioPlayerHelper.pauseAudio();
            } else {
              audioPlayerHelper.playAudio(widget.message);
            }
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          child: StreamBuilder<PlayerState>(
            stream: audioPlayerHelper.playerStateStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data?.playing ?? false;
              return Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isCurrentUser ? Theme.of(context).primaryColor : Colors.white,
              );
            },
          ),
        ),
        StreamBuilder<PositionData>(
          stream: audioPlayerHelper._positionDataStream,
          builder: (context, snapshot) {
            final completedPercentage = audioPlayerHelper.completedPercentage;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: isCurrentUser ? Theme.of(context).primaryColor : Colors.grey[700],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      value: completedPercentage,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayerHelper.playerStateStream,
          builder: (context, snapshotPlayerState) {
            final playerState = snapshotPlayerState.data;
            final processingState = playerState?.processingState;

            return StreamBuilder<PositionData>(
              stream: audioPlayerHelper._positionDataStream,
              builder: (context, snapshotDuration) {
                final loading = processingState == ProcessingState.loading;
                final currentDuration = audioPlayerHelper.currentDuration;
                final currentDurationText = loading ? 'Loading' : currentDuration;

                return Text(
                  currentDurationText,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                );
              },
            );
          },
        ),
        ],
      ),
    );
  }
}