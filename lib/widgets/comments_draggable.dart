import 'package:flutter/material.dart';
import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/services/database.service.dart';
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

  void makeSheetVisible() {
    _animateSheetTo(snaps[1]);
  }

  void makeSheetInvisible() {
    _animateSheetTo(snaps[0]);
  }

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
    } on Exception {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableScrollableSheet(
        controller: draggableController,
        initialChildSize: 0.0,
        minChildSize: 0.0,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: snaps,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 250, 246, 246),
            ),
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Commentaires",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
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
                                      child: const Text('Aucun commentaire')),
                                )
                              : ListView.separated(
                                  controller: scrollController,
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) => ListTile(
                                    title:
                                        CommentWidget(comment: comments[index]),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                ),
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                    hintText: 'Ajouter un commentaire...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () async {
                                  try {
                                    await _addComment();
                                    await _loadComments();
                                    _commentController.clear();
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
