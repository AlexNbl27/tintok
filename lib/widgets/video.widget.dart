import 'package:flutter/material.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/tools/extensions/context.extension.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Video video;
  const VideoPlayerWidget({super.key, required this.video});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = true;

  /// Méthode pour mettre à jour la vidéo sans recréer le widget
  void updateVideo(Video newVideo) {
    if (newVideo.videoUrl != widget.video.videoUrl) {
      _controller.dispose();
      _initializeController(newVideo);
    }
  }

  /// Initialisation du contrôleur vidéo
  void _initializeController(Video video) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.translations.errorLoadingVideo)));
      });

    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void initState() {
    super.initState();
    _initializeController(widget.video);
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
      _controller.dispose();
      _initializeController(widget.video);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlaying() => _controller.value.isPlaying ? pause() : play();

  void pause() {
    _controller.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void play() {
    _controller.play();
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(children: [
            VideoPlayer(_controller),
            if (!isPlaying)
              const Center(
                child: Icon(Icons.play_arrow, color: Colors.white, size: 75),
              )
          ])
        : const Center(child: CircularProgressIndicator());
  }
}
