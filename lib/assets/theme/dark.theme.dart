import 'dart:ui';
import 'package:flutter_tools_a3studio/flutter_tools_a3studio.dart';

class DarkTheme extends ATheme {
  @override
  Color get primary => const Color(0xFFE6465D);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get surface => const Color(0xFF121212);
  @override
  Color get onSurface => const Color(0xFFE0E0E0);
  @override
  Color get secondary => const Color(0xFFB15D5D);
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get success => const Color(0xFF66BB6A);
  @override
  Color get error => const Color(0xFFD32F2F);
  @override
  Color get onError => const Color(0xFFFFFFFF);
  @override
  Color get onSurfaceContainer => const Color(0xFF333333);
  @override
  Color get onTertiary => const Color(0xFF9E9E9E);
  @override
  Color get scrim => const Color(0x66000000);
  @override
  Color get shadow => const Color(0x80000000);
  @override
  Color get surfaceContainer => const Color(0xFF1E1E1E);
  @override
  Color get tertiary => const Color(0xFF3F51B5);
  @override
  Brightness get statusBarIconBrightness => Brightness.light;
  @override
  Brightness get statusBarBrightness => Brightness.dark;
  @override
  Brightness get systemNavigationBarIconBrightness => Brightness.light;
  @override
  Brightness get generalBrightness => Brightness.dark;
}
