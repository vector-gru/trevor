import 'package:balloon_pop/balloon_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Wraps the BalloonPopScreen from the balloon_pop package
/// and provides navigation back to Trevor's Room.
class BalloonPopPage extends ConsumerWidget {
  const BalloonPopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      // Scoped so game state resets on each visit
      overrides: const [],
      child: BalloonPopScreen(
        onBack: () => context.go('/'),
      ),
    );
  }
}
