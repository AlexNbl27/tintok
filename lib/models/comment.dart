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
}
