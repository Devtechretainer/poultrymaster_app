import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(
    // Wrap app with ProviderScope for Riverpod
    ProviderScope(
      child: DevicePreview(
        enabled: !kReleaseMode, // Only enable in debug mode
        builder: (context) => const PoultryCoreApp(),
      ),
    ),
  );
}

class PoultryCoreApp extends StatelessWidget {
  const PoultryCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Device Preview integration
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      title: 'Poultry Core',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
