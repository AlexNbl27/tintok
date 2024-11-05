import 'package:flutter/material.dart';
import 'package:tintok/models/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => print('User ${comment.author.username} clicked'), //TODO
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(comment.author.avatarUrl ?? 'https://i.pinimg.com/236x/54/72/d1/5472d1b09d3d724228109d381d617326.jpg'),
            ),
          ),
          const SizedBox(width: 10),
          // Comment content
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and date
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: comment.author.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: _formatDate(comment.date),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Comment text
                Text(
                  comment.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format the date to a more user-friendly format
    return '${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}';
  }
}
