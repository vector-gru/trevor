import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/shared_ui.dart';

void main() {
  test('TrevorColors constants are defined', () {
    // Verify that color constants are opaque (alpha == 1.0)
    expect(TrevorColors.coral.a, 1.0);
    expect(TrevorColors.skyBlue.a, 1.0);
    expect(TrevorColors.textDark.a, 1.0);
  });
}
