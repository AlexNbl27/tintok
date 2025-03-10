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

  Video({
    required this.uuid,
    this.title,
    this.description,
    required this.createdAt,
    required this.author,
    required this.videoUrl,
  });

  factory Video.fromMap(Map<String, dynamic> map, {User? author}) {
    return Video(
      uuid: map['uuid'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      author: author ?? (User(username: "Unknown", uuid: "", createdAt: DateTime.now())),
      videoUrl: map['url'],
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
          limit: nbCommentsPerPage,
          joinTables: [SupabaseConstant.usersTable]);
      return list.map((comment) {
        return Comment.fromMap(comment,
            author: User.fromMap(comment[SupabaseConstant.usersTable]));
      }).toList();
    } on Exception {
      throw Exception('Error while fetching comments');
    }
  }
}
