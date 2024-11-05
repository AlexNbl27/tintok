import 'package:flutter/material.dart';
import 'package:tintok/models/comment.dart';
import 'package:tintok/models/post.model.dart';
import 'package:tintok/widgets/appbar.widget.dart';
import 'package:tintok/widgets/comment_card.widget.dart';
import 'package:tintok/models/user.model.dart';
import 'package:tintok/screens/user_profile.dart';
import 'package:tintok/widgets/gestures_moves.dart';
import 'package:tintok/widgets/video.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<double> snaps = const [0, 0.6, 1];
  final Duration animationDuration = const Duration(milliseconds: 500);
  final Curve animationCurve = Curves.easeInOut;
  final DraggableScrollableController draggableController =
      DraggableScrollableController();
  late Post currentPost;

  @override
  void initState() {
    super.initState();
    currentPost = Post(
      videoUrl:
          "https://videos.pexels.com/video-files/28915821/12515365_1440_2560_60fps.mp4",
      miniatureUrl:
          "https://w0.peakpx.com/wallpaper/82/735/HD-wallpaper-iphone-for-iphone-12-iphone-11-and-iphone-x-iphone-wallp-fond-d-ecran-telephone-fond-d-ecran-iphone-apple-fond-ecran-gratuit-paysage-cool-sphere.jpg",
      comments: [
        Comment(
          date: DateTime.now(),
          text: "Commentaire 1",
          author: User(
            uuid: "151",
            username: "johndoe",
            email: "johndoe@gmail.com",
            avatarUrl:
                "https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png",
          ),
        ),
        Comment(
          date: DateTime.now(),
          text: "Commentaire 2",
          author: User(
            uuid: "151",
            username: "johndoe",
            email: "johndoe@gmail.com",
            avatarUrl:
                "https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png",
          ),
        ),
      ],
      uuid: "1",
      title: "Post",
      author: User(
        uuid: "151",
        username: "johndoe",
        email: "johndoe@gmail.com",
        avatarUrl:
            "https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png",
      ),
    );
  }

  void _makeSheetVisible() {
    _animateSheetTo(snaps[1]);
  }

  void _makeSheetInvisible() {
    _animateSheetTo(snaps[0]);
  }

  void _animateSheetTo(double snap) {
    draggableController.animateTo(snap,
        duration: animationDuration, curve: animationCurve);
  }

  Widget _buildBottomSheet() {
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
          return _buildBottomSheetContent(context, scrollController);
        },
      ),
    );
  }

  Widget _buildBottomSheetContent(
      BuildContext context, ScrollController scrollController) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 250, 246, 246),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildGesturesMoves(scrollController),
          const SizedBox(height: 8),
          _buildCommentsList(scrollController),
        ],
      ),
    );
  }

  Widget _buildGesturesMoves(ScrollController scrollController) {
    return GesturesMoves(
      onTap: () {
        scrollController.animateTo(0,
            duration: animationDuration, curve: animationCurve);
      },
      onSwipeUp: () {
        _animateSheetTo(snaps.last);
      },
      onSwipeDown: () {
        _animateSheetTo(snaps[1]);
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Commentaires",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(ScrollController scrollController) {
    return Flexible(
      child: ListView.separated(
        controller: scrollController,
        itemCount: currentPost.comments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: CommentWidget(
              comment: currentPost.comments[index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final GlobalKey<VideoPlayerWidgetState> videoPlayerKey =
        GlobalKey<VideoPlayerWidgetState>();
    return GesturesMoves(
      onLongPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfile(
              user: currentPost.author,
            ),
          ),
        );
      },
      onSwipeRight: () {},
      onSwipeLeft: () {},
      onSwipeUp: () => _makeSheetVisible(),
      onTap: () {
        _makeSheetInvisible();
        videoPlayerKey.currentState?.togglePlaying();
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          children: [
            VideoPlayerWidget(key: videoPlayerKey, post: currentPost),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MyAppBar(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainContent(context),
        _buildBottomSheet(),
      ],
    );
  }
}
