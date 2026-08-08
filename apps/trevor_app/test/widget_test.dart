import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trevor_app/app.dart';

void main() {
  testWidgets('Trevor app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TrevorApp()));
    // App renders without crashing
    expect(find.byType(TrevorApp), findsOneWidget);
  });
}
