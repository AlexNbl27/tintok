import 'package:flutter/material.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/widgets/comments_draggable.dart';
import 'package:tintok/widgets/gestures_moves.dart';
import 'package:tintok/widgets/video.widget.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key, required this.video});
  final Video video;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<VideoPlayerWidgetState> videoPlayerKey =
        GlobalKey<VideoPlayerWidgetState>();
    final GlobalKey<CommentsDraggableState> commentsKey =
        GlobalKey<CommentsDraggableState>();
    return Scaffold(
      appBar: AppBar(title: Text(video.title ?? '')),
      body: Stack(
        children: [
          GesturesMoves(
            child: VideoPlayerWidget(video: video, key: videoPlayerKey),
            onTap: () {
              commentsKey.currentState?.makeSheetInvisible();
              videoPlayerKey.currentState?.togglePlaying();
            },
            onSwipeUp: () => commentsKey.currentState?.makeSheetVisible(),
          ),
          CommentsDraggable(currentVideo: video, key: commentsKey),
        ],
      ),
    );
  }
}
