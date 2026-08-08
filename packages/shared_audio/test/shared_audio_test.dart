import 'package:flutter_test/flutter_test.dart';
import 'package:shared_audio/shared_audio.dart';

void main() {
  test('SoundId has valid paths', () {
    for (final sound in SoundId.values) {
      expect(sound.path, isNotEmpty);
    }
  });
}
