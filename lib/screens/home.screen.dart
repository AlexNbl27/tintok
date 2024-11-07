import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tintok/constants/supabase.constant.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/video.model.dart';
import 'package:tintok/services/authentication.service.dart';
import 'package:tintok/services/database.service.dart';
import 'package:tintok/widgets/appbar.widget.dart';
import 'package:tintok/widgets/comment_card.widget.dart';
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
  late Video currentVideo;

  GlobalKey<CommentsDraggableState> commentsKey =
      GlobalKey<CommentsDraggableState>();

  Future<Video> _getVideo() async {
    final AuthenticationService auth = AuthenticationService.instance;
    return await database
        .getElements(
            table: SupabaseConstant.videosTable,
            limit: 1,
            conditionOnColumn: 'author_uuid',
            conditionValue: auth.currentUser)
        .then((value) {
      return Video.fromMap(value[0]);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildMainContent(BuildContext context) {
    final GlobalKey<VideoPlayerWidgetState> videoPlayerKey =
        GlobalKey<VideoPlayerWidgetState>();
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
      onSwipeRight: () {},
      onSwipeLeft: () {},
      onSwipeUp: () => commentsKey.currentState?.makeSheetVisible(),
      onTap: () {
        commentsKey.currentState?.makeSheetInvisible();
        videoPlayerKey.currentState?.togglePlaying();
      },
      child: Stack(
        children: [
          VideoPlayerWidget(key: videoPlayerKey, video: currentVideo),
          const Positioned(top: 0, left: 0, right: 0, child: MyAppBar()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Video>(
      future: _getVideo(),
      builder: (BuildContext context, AsyncSnapshot<Video> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (snapshot.hasData) {
          currentVideo = snapshot.data!;

          return Stack(
            children: [
              _buildMainContent(context), // Utiliser la vidéo ici
              CommentsDraggable(currentVideo: currentVideo, key: commentsKey),
            ],
          );
        } else {
          return Center(child: Text('Aucune vidéo trouvée.'));
        }
      },
    );
  }
}
