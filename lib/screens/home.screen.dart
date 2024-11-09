import 'package:flutter/material.dart';
import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/services/database.service.dart';
import 'package:tintok/widgets/appbar.widget.dart';
import 'package:tintok/screens/user_profile.dart';
import 'package:tintok/widgets/comments_draggable.dart';
import 'package:tintok/widgets/gestures_moves.dart';
import 'package:tintok/widgets/video.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<double> snaps = const [0, 0.6, 1];
  final DatabaseService database = DatabaseService.instance;
  final Duration animationDuration = const Duration(milliseconds: 500);
  final Curve animationCurve = Curves.easeInOut;
  final DraggableScrollableController draggableController =
      DraggableScrollableController();
  List<Comment> comments = [];
  List<Video> videoQueue = [];
  int currentVideoIndex = 0;
  late Video currentVideo;

  GlobalKey<CommentsDraggableState> commentsKey =
      GlobalKey<CommentsDraggableState>();

  GlobalKey<VideoPlayerWidgetState> videoPlayerKey =
      GlobalKey<VideoPlayerWidgetState>();

  Future<void> _loadVideos() async {
    final AuthenticationService auth = AuthenticationService.instance;
    final videosData = await database.getElements(
      table: SupabaseConstant.videosTable,
      limit: 5,
      joinTables: [SupabaseConstant.usersTable],
      relationships: {'user': 'user!Videos_author_uuid_fkey'},
      conditionOnColumn: 'author_uuid',
      conditionValue: auth.currentUser!.id,
      conditionType: ConditionType.notEqual,
    );
    setState(() {
      videoQueue = videosData.map((data) => Video.fromMap(data)).toList();
      currentVideo = videoQueue[currentVideoIndex];
    });
  }

  void _nextVideo() async {
    setState(() {
      videoQueue.removeAt(0);
    });

    final newVideo = await database.getElements(
      table: SupabaseConstant.videosTable,
      limit: 1,
      offset: videoQueue.length + currentVideoIndex,
      joinTables: [SupabaseConstant.usersTable],
      relationships: {'user': 'user!Videos_author_uuid_fkey'},
      conditionOnColumn: 'author_uuid',
      conditionValue: AuthenticationService.instance.currentUser!.id,
      conditionType: ConditionType.notEqual,
    );

    if (newVideo.isNotEmpty) {
      setState(() {
        videoQueue.add(Video.fromMap(newVideo[0]));
      });
    }

    if (videoQueue.isNotEmpty) {
      setState(() {
        currentVideoIndex = 0;
        currentVideo = videoQueue[currentVideoIndex];
      });
      videoPlayerKey.currentState?.updateVideo(currentVideo);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Widget _buildMainContent(BuildContext context) {
    return GesturesMoves(
      onLongPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfile(
              user: currentVideo.author,
            ),
          ),
        );
      },
      onSwipeRight: () {
        _nextVideo();
        database.insertElement(
          table: SupabaseConstant.likedVideosTable,
          values: {
            'video_uuid': currentVideo.uuid,
            'user_uuid': AuthenticationService.instance.currentUser!.id,
          },
        );
      },
      onSwipeLeft: _nextVideo,
      onSwipeUp: () {
        commentsKey.currentState?.makeSheetVisible();
        videoPlayerKey.currentState?.pause();
      },
      onTap: () {
        commentsKey.currentState?.makeSheetInvisible();
        videoPlayerKey.currentState?.togglePlaying();
      },
      child: VideoPlayerWidget(key: videoPlayerKey, video: currentVideo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return videoQueue.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              _buildMainContent(context),
              const Positioned(top: 0, left: 0, right: 0, child: MyAppBar()),
              CommentsDraggable(currentVideo: currentVideo, key: commentsKey),
            ],
          );
  }
}