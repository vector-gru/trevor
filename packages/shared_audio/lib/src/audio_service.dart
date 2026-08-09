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
  final _greetingPlayer = AudioPlayer(); // dedicated player for voice clips

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
    SoundId.balloonsStart,
    // trevorGreeting excluded — played via audioplayers (M4A)
  ];

  Future<void> init() async {
    // Initialise the SoLoud engine once — runs on its own C++ audio thread.
    await _soloud.init();

    await _musicPlayer.setVolume(0.04);

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
    _playSfx(sound, source);
  }

  Future<void> _playSfx(SoundId sound, AudioSource source) async {
    try {
      final handle = await _soloud.play(source, volume: 0.85);
      if (sound == SoundId.confetti) {
        _stopHalfway(source, handle);
      }
    } catch (e) {
      debugPrint('[AudioService] SFX error ${sound.name}: $e');
    }
  }

  Future<void> _stopHalfway(AudioSource source, SoundHandle handle) async {
    try {
      final duration = _soloud.getLength(source);
      await Future.delayed(duration ~/ 2);
      // Fade out over 300 ms rather than cutting abruptly.
      _soloud.fadeVolume(handle, 0, const Duration(milliseconds: 300));
      await Future.delayed(const Duration(milliseconds: 320));
      _soloud.stop(handle);
    } catch (_) {
      // Handle may already be finished — safe to ignore.
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

  void stopGreeting() {
    _greetingPlayer.stop();
  }

  /// Called when a game starts — stops greeting and plays the game intro clip.
  void playGameStart(SoundId introSound) {
    stopGreeting();
    playSound(introSound);
  }

  Future<void> stopMusic() => _musicPlayer.stop();

  /// Play the Trevor greeting voice clip via audioplayers (supports M4A).
  Future<void> playGreeting() async {
    if (_muted) return;
    try {
      await _greetingPlayer.stop();
      await _greetingPlayer.setReleaseMode(ReleaseMode.stop);
      await _greetingPlayer.setVolume(1.0);
      await _greetingPlayer.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );
      await _greetingPlayer.play(AssetSource(SoundId.trevorGreeting.path));
      debugPrint('[AudioService] Playing greeting');
    } catch (e) {
      debugPrint('[AudioService] Greeting error: $e');
    }
  }

  void setMuted(bool muted) {
    _muted = muted;
    if (muted) {
      _soloud.setGlobalVolume(0);
      _musicPlayer.setVolume(0);
    } else {
      _soloud.setGlobalVolume(1);
      _musicPlayer.setVolume(0.04);
    }
  }

  void toggleMute() => setMuted(!_muted);

  Future<void> dispose() async {
    for (final source in _sources.values) {
      await _soloud.disposeSource(source);
    }
    _sources.clear();
    _soloud.deinit();
    await _greetingPlayer.dispose();
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
