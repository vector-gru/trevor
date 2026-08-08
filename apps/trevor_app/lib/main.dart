import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait — better experience for young children
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Full-screen immersive for distraction-free play
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Storage
  await Hive.initFlutter();

  runApp(const ProviderScope(child: TrevorApp()));
}
