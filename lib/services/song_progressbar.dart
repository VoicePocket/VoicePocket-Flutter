import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class SongProgressBar extends StatefulWidget {
  final double barHeight;
  final Color progressBarColor;
  final Color thumbColor;
  final Duration progress;
  final Duration buffered;
  final Duration total;
  final void Function(Duration) onSeek;

  const SongProgressBar(
      {Key? key,
      required this.barHeight,
      required this.progressBarColor,
      required this.thumbColor,
      required this.progress,
      required this.buffered,
      required this.total,
      required this.onSeek
      })
      : super(key: key);

  @override
  State<SongProgressBar> createState() => _SongProgressBarState();
}

class _SongProgressBarState extends State<SongProgressBar> {
  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      barHeight: widget.barHeight,
      progressBarColor: widget.progressBarColor,
      thumbColor: widget.thumbColor,
      progress: widget.progress,
      buffered: widget.buffered,
      total: widget.total,
      onSeek: widget.onSeek,
    );
  }
}