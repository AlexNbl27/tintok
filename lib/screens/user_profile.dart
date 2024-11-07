import 'package:flutter/material.dart';
import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/services/database.service.dart';
import 'package:tintok/widgets/preview_video.widget.dart';

class UserProfile extends StatelessWidget {
  final User user;
  final DatabaseService database = DatabaseService.instance;

  UserProfile({super.key, required this.user});

  Future<List<Video>> _getLikedVideos() async {
    return await database.getElements(
      table: SupabaseConstant.likedVideosTable,
      conditionOnColumn: 'user_uuid',
      conditionType: ConditionType.equal,
      conditionValue: user.uuid,
      joinTables: [SupabaseConstant.videosTable],
    ).then((List<Map<String, dynamic>> likes) async {
      return Future.wait(likes.map((like) async {
        final videoMap = like['video'] as Map<String, dynamic>;
        return await Video.fromMap(videoMap);
      }).toList());
    });
  }

  Future<List<Video>> _getCreatedVideos() async {
    final videoMaps = await database.getElements(
      table: SupabaseConstant.videosTable,
      conditionOnColumn: 'author_uuid',
      conditionType: ConditionType.equal,
      conditionValue: user.uuid,
    );
    return Future.wait(
        videoMaps.map((e) async => await Video.fromMap(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Deux onglets : Posts et Comments
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.username),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Vidéos créées"),
              Tab(text: "Vidéos likées"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Video>>(
              future: _getCreatedVideos(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return PostsTab(videos: snapshot.data!);
                } else {
                  return const Center(child: Text('Aucune vidéo trouvée.'));
                }
              },
            ),
            FutureBuilder<List<Video>>(
              future: _getLikedVideos(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return PostsTab(videos: snapshot.data!);
                } else {
                  return const Center(child: Text('Aucune vidéo trouvée.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PostsTab extends StatelessWidget {
  final List<Video> videos;
  const PostsTab({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: videos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 9 / 16,
      ),
      itemBuilder: (context, index) {
        final video = videos[index];
        return ClipRRect(
          child: PreviewVideoWidget(
            video: video,
          ),
        );
      },
    );
  }
}
