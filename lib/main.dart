import 'package:flutter/material.dart';

import 'package:gestion_inventario/config/router/app_router.dart';

import 'package:gestion_inventario/config/theme/app_theme.dart';

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
