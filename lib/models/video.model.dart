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

  static Future<Video> fromMap(Map<String, dynamic> map) async {
    final user = await User.getFromUuid(map['author_uuid']);
    return Video(
      uuid: map['uuid'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      author: user,
      videoUrl: map['url'],
      miniatureUrl:
          "https://w0.peakpx.com/wallpaper/82/735/HD-wallpaper-iphone-for-iphone-12-iphone-11-and-iphone-x-iphone-wallp-fond-d-ecran-telephone-fond-d-ecran-iphone-apple-fond-ecran-gratuit-paysage-cool-sphere.jpg",
    );
  }

  Future<List<Comment>> getComments({required int pagination}) async {
    final DatabaseService database = DatabaseService.instance;
    const int nbCommentsPerPage = 10;
    await database
        .getElements(
            table: SupabaseConstant.commentsTable,
            conditionOnColumn: 'video_uuid',
            conditionValue: uuid,
            conditionType: ConditionType.equal,
            offset: pagination * nbCommentsPerPage,
            limit: nbCommentsPerPage)
        .then((value) {
      return (value as List).map((e) => Comment.fromMap(e)).toList();
    });
    throw Exception('Error while fetching comments');
  }
}
