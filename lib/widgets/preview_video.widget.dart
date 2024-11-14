import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/screens/video.screen.dart';
import 'package:tintok/tools/extensions/context.extension.dart';

class PreviewVideoWidget extends StatefulWidget {
  final Video video;

  const PreviewVideoWidget({
    super.key,
    required this.video,
  });

  @override
  PreviewVideoWidgetState createState() => PreviewVideoWidgetState();
}

class PreviewVideoWidgetState extends State<PreviewVideoWidget>
    with AutomaticKeepAliveClientMixin<PreviewVideoWidget> {
  Future<Uint8List?> _generateThumbnail() async {
    return await VideoThumbnail.thumbnailData(
      video: widget.video.videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Uint8List?>(
      future: _generateThumbnail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Skeletonizer.zone(
              enabled: true,
              child: AspectRatio(aspectRatio: 16 / 9, child: Bone.square()));
        } else if (snapshot.hasError) {
          return Center(child: Text(context.translations.errorLoadingVideo));
        } else if (!snapshot.hasData) {
          return Center(
              child: Text(context.translations.errorLoadingThumbnail));
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(video: widget.video),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(snapshot.data!),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        );
      },
    );
  }
}
