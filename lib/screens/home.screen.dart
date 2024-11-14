import 'package:flutter/material.dart';
import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/services/database.service.dart';
import 'package:tintok/tools/extensions/context.extension.dart';
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
  final DraggableScrollableController draggableController = DraggableScrollableController();
  List<Comment> comments = [];
  List<Video> videoQueue = [];
  int currentVideoIndex = 0;
  late Video? currentVideo;
  int globalVideoIndex = 0;
  bool noMoreVideos = false;

  GlobalKey<CommentsDraggableState> commentsKey = GlobalKey<CommentsDraggableState>();
  GlobalKey<VideoPlayerWidgetState> videoPlayerKey = GlobalKey<VideoPlayerWidgetState>();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    globalVideoIndex = 0;
    final videosData = await _fetchVideos();
    setState(() {
      videoQueue = videosData;
      currentVideo = videoQueue.isNotEmpty ? videoQueue[currentVideoIndex] : null;
      noMoreVideos = videoQueue.isEmpty;
    });
  }

  Future<List<Video>> _fetchVideos({int offset = 0}) async {
    final AuthenticationService auth = AuthenticationService.instance;
    final videosData = await database.getElements(
      table: SupabaseConstant.videosTable,
      limit: 5,
      offset: offset,
      joinTables: [SupabaseConstant.usersTable],
      relationships: {'user': 'user!Videos_author_uuid_fkey'},
      conditionOnColumn: 'author_uuid',
      conditionValue: auth.currentUser!.id,
      conditionType: ConditionType.notEqual,
    );
    return videosData
        .map((data) => Video.fromMap(data, author: User.fromMap(data[SupabaseConstant.usersTable])))
        .toList();
  }

  void _nextVideo() async {
    setState(() {
      videoQueue.removeAt(0);
      globalVideoIndex++;
    });

    if (videoQueue.isEmpty) {
      await _loadMoreVideos();
    }

    if (videoQueue.isNotEmpty) {
      setState(() {
        currentVideoIndex = 0;
        currentVideo = videoQueue[currentVideoIndex];
      });
      videoPlayerKey.currentState?.updateVideo(currentVideo!);
    }
  }

  Future<void> _loadMoreVideos() async {
    final newVideos = await _fetchVideos(offset: globalVideoIndex);

    if (newVideos.isNotEmpty) {
      setState(() {
        videoQueue.addAll(newVideos);
      });
    } else {
      setState(() {
        noMoreVideos = true;
      });
    }
  }

  Widget _buildMainContent(BuildContext context) {
    return GesturesMoves(
      onLongPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfile(
              user: currentVideo!.author,
            ),
          ),
        );
      },
      onSwipeRight: () {
        _nextVideo();
        database.insertElement(
          table: SupabaseConstant.likedVideosTable,
          values: {
            'video_uuid': currentVideo!.uuid,
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
      child: VideoPlayerWidget(key: videoPlayerKey, video: currentVideo!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (videoQueue.isEmpty && noMoreVideos) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              context.translations.noVideoFound,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
                onPressed: () => _loadVideos(),
                icon: const Icon(Icons.refresh),
                label: Text(context.translations.reload,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary)),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary))),
          ],
        ),
      );
    }

    return videoQueue.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              _buildMainContent(context),
              const Positioned(top: 0, left: 0, right: 0, child: MyAppBar()),
              CommentsDraggable(currentVideo: currentVideo!, key: commentsKey),
            ],
          );
  }
}