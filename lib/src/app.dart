import 'package:flutter/material.dart';

import 'routes/site_router.dart';

class AQoongApp extends StatelessWidget {
  AQoongApp({super.key});

  final SiteRouterDelegate _routerDelegate = SiteRouterDelegate();
  final SiteRouteInformationParser _routeInformationParser =
      const SiteRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF2563EB);

    return MaterialApp.router(
      title: 'AQoong.dev - Products, Flutter & Android Libraries',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        fontFamily: 'Arial',
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
