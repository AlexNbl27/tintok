import 'package:flutter/material.dart';
import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/services/database.service.dart';
import 'package:tintok/tools/extensions/context.extension.dart';
import 'package:tintok/widgets/comment_card.widget.dart';

class CommentsDraggable extends StatefulWidget {
  final Video currentVideo;
  const CommentsDraggable({super.key, required this.currentVideo});

  @override
  CommentsDraggableState createState() => CommentsDraggableState();
}

class CommentsDraggableState extends State<CommentsDraggable> {
  List<Comment> comments = [];
  bool isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  final DraggableScrollableController draggableController =
      DraggableScrollableController();

  final List<double> snaps = const [0, 0.6, 1];
  final Duration animationDuration = const Duration(milliseconds: 500);
  final Curve animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => isLoading = true);
    try {
      final newComments =
          await widget.currentVideo.getComments(pagination: 0) ?? [];
      setState(() {
        comments = newComments;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _animateSheetTo(double snap) {
    draggableController.animateTo(snap,
        duration: animationDuration, curve: animationCurve);
  }

  void makeSheetVisible() => _animateSheetTo(snaps[1]);

  void makeSheetInvisible() => _animateSheetTo(snaps[0]);

  Future<void> _addComment() async {
    final DatabaseService database = DatabaseService.instance;
    final AuthenticationService auth = AuthenticationService.instance;
    try {
      await database.insertElement(
        table: SupabaseConstant.commentsTable,
        values: {
          'video_uuid': widget.currentVideo.uuid,
          'author_uuid': auth.currentUser!.id,
          'content': _commentController.text,
        },
      );
      _commentController.clear();
      await _loadComments();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Theme.of(context).colorScheme.onSurface,
                displayColor: Theme.of(context).colorScheme.onSurface,
              ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: DraggableScrollableSheet(
          controller: draggableController,
          initialChildSize: 0.0,
          minChildSize: 0.0,
          maxChildSize: 1.0,
          snap: true,
          snapSizes: snaps,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 64),
                            child: comments.isEmpty
                                ? Center(
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Text(
                                          context.translations.noCommentFound,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                    ),
                                  )
                                : ListView.separated(
                                    controller: scrollController,
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) => ListTile(
                                      title: CommentWidget(
                                          comment: comments[index]),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary.withOpacity(0.1)),
                                  ),
                          ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildCommentInput(context)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: context.translations.addComment))),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: (){
              if (_commentController.text.isNotEmpty) {
                _addComment();
              }
            }
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
