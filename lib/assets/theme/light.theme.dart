import 'package:flutter/material.dart';
import 'package:flutter_tools_a3studio/flutter_tools_a3studio.dart';

class LightTheme extends ATheme {
  @override
  Color get primary => const Color(0xFFE6465D);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get surface => const Color(0xFFFFFFFF);
  @override
  Color get onSurface => const Color(0xFF333333);
  @override
  Color get secondary => const Color(0xFFFF6E40);
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get success => const Color(0xFF4CAF50);
  @override
  Color get error => const Color(0xFFD32F2F);
  @override
  Color get onError => const Color(0xFFFFFFFF);
  @override
  Color get onSurfaceContainer => const Color(0xFFFAFAFA);
  @override
  Color get onTertiary => const Color(0xFF757575);
  @override
  Color get scrim => const Color(0x66000000);
  @override
  Color get shadow => const Color(0x33000000);
  @override
  Color get surfaceContainer => const Color(0xFFF5F5F5);
  @override
  Color get tertiary => const Color(0xFF3F51B5);

  @override
  Brightness get statusBarIconBrightness => Brightness.dark;
  @override
  Brightness get statusBarBrightness => Brightness.light;
  @override
  Brightness get systemNavigationBarIconBrightness => Brightness.dark;
  @override
  Brightness get generalBrightness => Brightness.light;

  @override
  get buttonBackgroundColor => WidgetStatePropertyAll<Color>(primary);
  @override
  EdgeInsetsGeometry get buttonPadding => const EdgeInsets.all(16);
}
