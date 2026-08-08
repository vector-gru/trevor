import 'package:flutter/material.dart';

/// All balloon variants in Balloon Pop.
enum BalloonType {
  red,
  rainbow,
  golden,
  gift,
  animal;

  int get points => switch (this) {
        BalloonType.red => 1,
        BalloonType.rainbow => 5,
        BalloonType.golden => 10,
        BalloonType.gift => 3,
        BalloonType.animal => 3,
      };

  Color get color => switch (this) {
        BalloonType.red => const Color(0xFFE53935),
        BalloonType.rainbow => const Color(0xFFAB47BC),
        BalloonType.golden => const Color(0xFFFFD600),
        BalloonType.gift => const Color(0xFF00ACC1),
        BalloonType.animal => const Color(0xFF66BB6A),
      };

  String get emoji => switch (this) {
        BalloonType.red => '🎈',
        BalloonType.rainbow => '🌈',
        BalloonType.golden => '⭐',
        BalloonType.gift => '🎁',
        BalloonType.animal => '🐻',
      };

  /// How rare is this balloon (lower = rarer). Weights used for random spawn.
  double get spawnWeight => switch (this) {
        BalloonType.red => 0.55,
        BalloonType.rainbow => 0.20,
        BalloonType.golden => 0.05,
        BalloonType.gift => 0.10,
        BalloonType.animal => 0.10,
      };
}
