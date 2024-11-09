import 'package:flutter/material.dart';
import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/services/database.service.dart';
import 'package:tintok/tools/extensions/context.extension.dart';
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
      return likes.map((like) {
        final videoMap = like['video'] as Map<String, dynamic>;
        return Video.fromMap(videoMap);
      }).toList();
    });
  }

  Future<List<Video>> _getCreatedVideos() async {
    final videoMaps = await database.getElements(
      table: SupabaseConstant.videosTable,
      conditionOnColumn: 'author_uuid',
      conditionType: ConditionType.equal,
      conditionValue: user.uuid,
    );
    return videoMaps.map((videoMap) => Video.fromMap(videoMap)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          iconTheme:  IconThemeData(color: Theme.of(context).colorScheme.onSurface),
          title: Text(user.username),
          bottom: TabBar(
            tabs: [
              Tab(text: context.translations.createdVideos),
              Tab(text: context.translations.likedVideos),
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
                  return Center(child: Text('${context.translations.error} : ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return PostsTab(videos: snapshot.data!);
                } else {
                  return Center(child: Text(context.translations.noVideoFound));
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
                  return Center(child: Text('${context.translations.error} : ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return PostsTab(videos: snapshot.data!);
                } else {
                  return Center(child: Text(context.translations.noVideoFound));
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
