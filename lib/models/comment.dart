import 'package:tintok/models/user.model.dart';

class Comment {
  final String text;
  final User author;
  final DateTime date;

  Comment({
    required this.text,
    required this.author,
    required this.date,
  });

  factory Comment.fromMap(Map<String, dynamic> map, {User? author}) {
    return Comment(
      text: map['content'],
      author: author != null
          ? User.fromMap(map['user'])
          : (User(username: "Unknown", uuid: "", createdAt: DateTime.now())),
      date: DateTime.parse(map['created_at']),
    );
  }
}
