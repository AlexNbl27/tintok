import 'package:flutter/material.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/screens/user_profile.dart';
import 'package:tintok/tools/extensions/context.extension.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;

  const CommentWidget({
    super.key,
    required this.comment,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  user: widget.comment.author,
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.comment.author.avatarUrl ??
                'https://i.pinimg.com/236x/54/72/d1/5472d1b09d3d724228109d381d617326.jpg'),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(text: widget.comment.author.username),
                    const TextSpan(text: ' '),
                    TextSpan(text: _formatDate(widget.comment.date)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              if (_isExpanded || widget.comment.text.length <= 150)
                Text(widget.comment.text)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.comment.text.substring(0, 150)}...',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = true;
                        });
                      },
                      child: Text(
                        context.translations.seeMore,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.day}/${date.month}/${date.year}';
  }
}
