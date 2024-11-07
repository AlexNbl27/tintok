import 'package:flutter/material.dart';
import 'package:tintok/models/video.model.dart';

class PreviewVideoWidget extends StatelessWidget {
  final Video post;

  const PreviewVideoWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Video ${post.uuid} clicked'),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(post.miniatureUrl),
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
  }
}
