import 'package:tintok/models/comment.dart';
import 'package:tintok/models/user.model.dart';

class Post {
  final String uuid;
  final User author;
  final String title;
  final String videoUrl;
  final String miniatureUrl;
  final List<Comment> comments;

  Post({
    required this.uuid,
    required this.title,
    required this.author,
    required this.videoUrl,
    required this.miniatureUrl,
    required this.comments,
  });
}
