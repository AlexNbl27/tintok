import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/services/database.service.dart';

class Video {
  final String uuid;
  final User author;
  final String? title;
  final String? description;
  final DateTime createdAt;
  final String videoUrl;
  final String miniatureUrl;

  Video({
    required this.uuid,
    this.title,
    this.description,
    required this.createdAt,
    required this.author,
    required this.videoUrl,
    required this.miniatureUrl,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      uuid: map['uuid'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      author: map['user'] != null
          ? User.fromMap(map['user'])
          : (User(username: "Unknown", uuid: "", createdAt: DateTime.now())),
      videoUrl: map['url'],
      miniatureUrl:
          "https://w0.peakpx.com/wallpaper/82/735/HD-wallpaper-iphone-for-iphone-12-iphone-11-and-iphone-x-iphone-wallp-fond-d-ecran-telephone-fond-d-ecran-iphone-apple-fond-ecran-gratuit-paysage-cool-sphere.jpg",
    );
  }

  Future<List<Comment>?> getComments({required int pagination}) async {
    final DatabaseService database = DatabaseService.instance;
    const int nbCommentsPerPage = 10;
    try {
      List<Map<String, dynamic>> list = await database.getElements(
          table: SupabaseConstant.commentsTable,
          conditionOnColumn: 'video_uuid',
          conditionValue: uuid,
          conditionType: ConditionType.equal,
          offset: pagination * nbCommentsPerPage,
          limit: nbCommentsPerPage);
      List<Comment> comments = await Future.wait(
          list.map((map) async => await Comment.fromMap(map)));
      return comments;
    } on Exception {
      throw Exception('Error while fetching comments');
    }
  }
}
