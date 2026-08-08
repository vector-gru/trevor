import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/room/room_screen.dart';
import 'features/balloon_pop/balloon_pop_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const RoomScreen()),
      GoRoute(
        path: '/balloon-pop',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const BalloonPopPage(),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
    ],
  );
});
