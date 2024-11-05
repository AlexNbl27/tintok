import 'package:flutter/material.dart';
import 'package:tintok/models/post.model.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Post post;
  const VideoPlayerWidget({super.key, required this.post});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.post.videoUrl))
          ..initialize().then((_) {
            _isInitialized = true;
            setState(() {});
          });
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlaying() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Stack(
            children: [
              AspectRatio(
                aspectRatio: MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height,
                child: VideoPlayer(_controller),
              ),
              if (!_isPlaying)
                const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 75,
                  ),
                ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
