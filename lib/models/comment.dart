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

  static fromMap(Map<String, dynamic> map) async {
    User author = await User.getFromUuid('');
    return Comment(
      text: map['content'],
      author: author,
      date: DateTime.parse(map['created_at']),
    );
  }
}
