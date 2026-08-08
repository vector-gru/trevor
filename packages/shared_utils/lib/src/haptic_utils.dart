import 'package:flutter/services.dart';

/// Wrapper around haptic feedback for consistent usage across the app.
class HapticUtils {
  HapticUtils._();

  /// Light tap — used for regular taps on objects.
  static Future<void> tap() => HapticFeedback.lightImpact();

  /// Medium impact — used when a balloon pops.
  static Future<void> pop() => HapticFeedback.mediumImpact();

  /// Heavy — used for special/rare balloon pops.
  static Future<void> special() => HapticFeedback.heavyImpact();
}
