import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';

import 'router.dart';

class TrevorApp extends ConsumerWidget {
  const TrevorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Trevor',
      debugShowCheckedModeBanner: false,
      theme: TrevorTheme.light,
      routerConfig: router,
    );
  }
}
