import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sound_id.dart';

/// Manages all audio playback for the Trevor app.
///
/// SFX uses [AudioPool] with [PlayerMode.lowLatency].
/// On Android this switches the backing implementation from MediaPlayer
/// to SoundPool — the native low-latency audio path designed for game SFX.
/// Bytes are decoded and pinned in the audio server's memory; each play
/// is a single binder call with no prepareAsync overhead.
///
/// Background music uses a separate [AudioPlayer] in default mode
/// (MediaPlayer is appropriate for one long looping track).
class AudioService {
  final Map<SoundId, AudioPool> _pools = {};
  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _muted = false;
  bool _ready = false;

  bool get isMuted => _muted;

  static const _sfxSounds = [
    SoundId.balloonPop,
    SoundId.balloonRainbowPop,
    SoundId.balloonGoldenPop,
    SoundId.balloonGiftPop,
    SoundId.balloonAnimalPop,
    SoundId.starCollect,
    SoundId.confetti,
    SoundId.buttonTap,
    SoundId.roomEnter,
  ];

  Future<void> init() async {
    await _musicPlayer.setVolume(0.4);

    // Build one AudioPool per SFX sound.
    // minPlayers=2 pre-warms 2 instances so rapid taps never wait.
    // maxPlayers=4 allows up to 4 simultaneous plays of the same sound.
    // PlayerMode.lowLatency → SoundPool on Android, AVAudioEngine on iOS.
    for (final sound in _sfxSounds) {
      try {
        final pool = await AudioPool.createFromAsset(
          path: sound.path,
          minPlayers: 2,
          maxPlayers: 4,
          playerMode: PlayerMode.lowLatency,
        );
        _pools[sound] = pool;
      } catch (e) {
        debugPrint('[AudioService] Pool init failed for ${sound.name}: $e');
      }
    }

    _ready = true;
    debugPrint('[AudioService] Ready — ${_pools.length} pools initialised');
  }

  /// Fire-and-forget SFX play. Returns immediately.
  void playSound(SoundId sound) {
    if (_muted || !_ready) return;
    final pool = _pools[sound];
    if (pool == null) return;
    _startPool(pool, sound);
  }

  Future<void> _startPool(AudioPool pool, SoundId sound) async {
    try {
      await pool.start(volume: 0.85);
    } catch (e) {
      debugPrint('[AudioService] playSound error ${sound.name}: $e');
    }
  }

  Future<void> playMusic(SoundId music) async {
    if (_muted) return;
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource(music.path));
    } catch (e) {
      debugPrint('[AudioService] Music error ${music.name}: $e');
    }
  }

  Future<void> stopMusic() => _musicPlayer.stop();

  void setMuted(bool muted) {
    _muted = muted;
    _musicPlayer.setVolume(muted ? 0 : 0.4);
  }

  void toggleMute() => setMuted(!_muted);

  Future<void> dispose() async {
    for (final pool in _pools.values) {
      await pool.dispose();
    }
    _pools.clear();
    await _musicPlayer.dispose();
  }
}

/// Riverpod provider for the [AudioService].
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  service.init();
  ref.onDispose(service.dispose);
  return service;
});
