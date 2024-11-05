import 'package:flutter/material.dart';

class GesturesMoves extends StatelessWidget {
  static const int gestureOffset = 5;
  final Widget child;
  final Function? onTap;
  final Function? onSwipeRight;
  final Function? onSwipeLeft;
  final Function? onSwipeUp;
  final Function? onSwipeDown;
  final Function? onLongPress;

  const GesturesMoves(
      {super.key,
      required this.child,
      this.onSwipeRight,
      this.onSwipeLeft,
      this.onSwipeUp,
      this.onSwipeDown,
      this.onTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    bool messaging = false;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!();
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > gestureOffset && onSwipeRight != null) {
          if (!messaging) {
            messaging = true;
            onSwipeRight!();
          }
        } else if (details.delta.dx < -gestureOffset && onSwipeLeft != null) {
          // Swipe vers la gauche
          if (!messaging) {
            messaging = true;
            onSwipeLeft!();
          }
        }
      },
      onHorizontalDragEnd: (details) => messaging = false,
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > gestureOffset && onSwipeDown != null) {
          if (!messaging) {
            messaging = true;
            onSwipeDown!();
          }
        } else if (details.delta.dy < -gestureOffset && onSwipeUp != null) {
          if (!messaging) {
            messaging = true;
            onSwipeUp!();
          }
        }
      },
      onVerticalDragEnd: (details) => messaging = false,
      child: child,
    );
  }
}
