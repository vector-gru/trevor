import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'sound_id.dart';

/// Manages all audio playback for the Trevor app.
///
/// SFX uses [SoLoud] — a C++ audio engine (SoLoud) via dart:ffi.
/// There are NO method channels, NO MediaPlayer, NO audio focus requests.
/// All SFX calls are synchronous C interop that never touch the main thread
/// message loop, which eliminates the frame-skip problem entirely.
///
/// Background music uses [AudioPlayer] (audioplayers) which is fine for
/// a single looping track.
class AudioService {
  final _soloud = SoLoud.instance;
  final _musicPlayer = AudioPlayer();

  // Loaded sound sources — one per SFX file.
  final Map<SoundId, AudioSource> _sources = {};

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
    // Initialise the SoLoud engine once — runs on its own C++ audio thread.
    await _soloud.init();

    await _musicPlayer.setVolume(0.4);

    // Load each SFX into SoLoud memory. loadAsset decodes the MP3 to PCM
    // and pins it in the engine — play() after this is a single C call.
    for (final sound in _sfxSounds) {
      try {
        final bytes = await rootBundle.load('assets/${sound.path}');
        final source = await _soloud.loadMem(
          sound.name,
          bytes.buffer.asUint8List(),
        );
        _sources[sound] = source;
      } catch (e) {
        debugPrint('[AudioService] Failed to load ${sound.name}: $e');
      }
    }

    _ready = true;
    debugPrint(
      '[AudioService] SoLoud ready — ${_sources.length} sounds loaded',
    );
  }

  /// Play a sound effect. Synchronous C call — zero main-thread overhead.
  void playSound(SoundId sound) {
    if (_muted || !_ready) return;
    final source = _sources[sound];
    if (source == null) return;
    try {
      _soloud.play(source, volume: 0.85);
    } catch (e) {
      debugPrint('[AudioService] SFX error ${sound.name}: $e');
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
    if (muted) {
      _soloud.setGlobalVolume(0);
      _musicPlayer.setVolume(0);
    } else {
      _soloud.setGlobalVolume(1);
      _musicPlayer.setVolume(0.4);
    }
  }

  void toggleMute() => setMuted(!_muted);

  Future<void> dispose() async {
    for (final source in _sources.values) {
      await _soloud.disposeSource(source);
    }
    _sources.clear();
    _soloud.deinit();
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
