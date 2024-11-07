import 'package:flutter/material.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/widgets/comment_card.widget.dart';
import 'package:tintok/widgets/preview_video.widget.dart';

class UserProfile extends StatelessWidget {
  final User user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final post = Video(
      uuid: "1",
      title: "Video",
      author: user,
      videoUrl: "https://www.youtube.com/watch?v=x7JnA8ssuqY",
      miniatureUrl:
          "https://w0.peakpx.com/wallpaper/82/735/HD-wallpaper-iphone-for-iphone-12-iphone-11-and-iphone-x-iphone-wallp-fond-d-ecran-telephone-fond-d-ecran-iphone-apple-fond-ecran-gratuit-paysage-cool-sphere.jpg",
      createdAt: DateTime.now(),
    );
    return DefaultTabController(
      length: 2, // Deux onglets : Posts et Comments
      child: Scaffold(
        appBar: AppBar(
          title: Text('${user.username} \'s Profile'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Posts"), // Titre pour l'onglet Posts
              Tab(text: "Comments"), // Titre pour l'onglet Comments
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PostsTab(posts: [
              post,
              post,
              post,
              post,
              post,
            ]),
            CommentsTab(comments: [
              Comment(
                date: DateTime.now(),
                text: "Commentaire",
                author: user,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class PostsTab extends StatelessWidget {
  final List<Video> posts;

  const PostsTab({super.key, required this.posts});

  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 9 / 16,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        return ClipRRect(
          child: PreviewVideoWidget(
            post: post,
          ),
        );
      },
    );
  }
}

class CommentsTab extends StatelessWidget {
  final List<Comment> comments;

  const CommentsTab({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return CommentWidget(
          comment: comment,
        );
      },
    );
  }
}
