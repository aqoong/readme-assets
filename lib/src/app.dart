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
      routes: {
        SiteRoute.home.path: (_) => const HomePage(),
        SiteRoute.packages.path: (_) => const PackagesPage(),
        '${SiteRoute.packages.path}/': (_) => const PackagesPage(),
        SiteRoute.jsonParser.path: (_) => const JsonParserPage(),
        '${SiteRoute.jsonParser.path}/': (_) => const JsonParserPage(),
        SiteRoute.guide.path: (_) => const GuidePage(),
        '${SiteRoute.guide.path}/': (_) => const GuidePage(),
        SiteRoute.about.path: (_) => const AboutPage(),
        '${SiteRoute.about.path}/': (_) => const AboutPage(),
        SiteRoute.privacy.path: (_) => const PrivacyPage(),
        '${SiteRoute.privacy.path}/': (_) => const PrivacyPage(),
      },
      onUnknownRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => const HomePage(),
        settings: RouteSettings(name: SiteRoute.home.path),
      ),
    );
  }
}
