/// All sound effects and music tracks used across the Trevor app.
enum SoundId {
  // Balloon Pop SFX
  balloonPop,
  balloonRainbowPop,
  balloonGoldenPop,
  balloonGiftPop,
  balloonAnimalPop,

  // Star & reward SFX
  starCollect,
  levelUp,
  confetti,

  // UI SFX
  buttonTap,
  roomEnter,
  trevorGreeting,
  balloonsStart,

  // Music
  bgRoomTheme,
  bgBalloonPop;

  /// Path passed to [AssetSource].
  ///
  /// Flutter bundles assets from the pubspec `../../assets/` declaration
  /// under the stripped key `audio/...`, which audioplayers resolves
  /// as `assets/audio/...` internally.
  String get path => switch (this) {
    SoundId.balloonPop => 'audio/sfx/balloon_pop.mp3',
    SoundId.balloonRainbowPop => 'audio/sfx/balloon_rainbow_pop.mp3',
    SoundId.balloonGoldenPop => 'audio/sfx/balloon_golden_pop.mp3',
    SoundId.balloonGiftPop => 'audio/sfx/balloon_gift_pop.mp3',
    SoundId.balloonAnimalPop => 'audio/sfx/balloon_animal_pop.mp3',
    SoundId.starCollect => 'audio/sfx/star_collect.mp3',
    SoundId.levelUp => 'audio/sfx/level_up.mp3',
    SoundId.confetti => 'audio/sfx/confetti.mp3',
    SoundId.buttonTap => 'audio/sfx/button_tap.mp3',
    SoundId.roomEnter => 'audio/sfx/room_enter.mp3',
    SoundId.trevorGreeting => 'audio/sfx/trevor_greeting.m4a',
    SoundId.balloonsStart => 'audio/sfx/balloons_start.WAV',
    SoundId.bgRoomTheme => 'audio/music/room_theme.mp3',
    SoundId.bgBalloonPop => 'audio/music/balloon_pop_theme.mp3',
  };
}
