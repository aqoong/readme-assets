import 'package:flutter/material.dart';

import 'routes/site_route.dart';
import 'views/pages/about_page.dart';
import 'views/pages/guide_page.dart';
import 'views/pages/home_page.dart';
import 'views/pages/json_parser_page.dart';
import 'views/pages/packages_page.dart';
import 'views/pages/privacy_page.dart';

class AQoongApp extends StatelessWidget {
  const AQoongApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF2563EB);

    return MaterialApp(
      title: 'AQoong.dev - Flutter & Android Developer Libraries',
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
      onGenerateRoute: _buildRoute,
      onUnknownRoute: (_) =>
          _animatedRoute(SiteRoute.home.path, const HomePage()),
    );
  }
}

Route<void> _buildRoute(RouteSettings settings) {
  final path = _normalizePath(settings.name);

  return _animatedRoute(path, switch (path) {
    '/' => const HomePage(),
    '/packages' => const PackagesPage(),
    '/json-parser' => const JsonParserPage(),
    '/guide' => const GuidePage(),
    '/about' => const AboutPage(),
    '/privacy' => const PrivacyPage(),
    _ => const HomePage(),
  });
}

String _normalizePath(String? path) {
  if (path == null || path.isEmpty) {
    return SiteRoute.home.path;
  }
  if (path.length > 1 && path.endsWith('/')) {
    return path.substring(0, path.length - 1);
  }
  return path;
}

PageRouteBuilder<void> _animatedRoute(String path, Widget page) {
  return PageRouteBuilder<void>(
    pageBuilder: (_, _, _) => page,
    settings: RouteSettings(name: path),
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.025, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
