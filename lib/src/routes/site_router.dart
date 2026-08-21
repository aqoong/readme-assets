import 'package:flutter/material.dart';

import '../views/pages/about_page.dart';
import '../views/pages/article_detail_page.dart';
import '../views/pages/articles_page.dart';
import '../views/pages/home_page.dart';
import '../views/pages/ip_address_page.dart';
import '../views/pages/json_parser_page.dart';
import '../views/pages/not_found_page.dart';
import '../views/pages/package_detail_page.dart';
import '../views/pages/packages_page.dart';
import '../views/pages/privacy_page.dart';
import '../views/pages/product_detail_page.dart';
import '../views/pages/products_page.dart';
import '../views/pages/qr_code_generator_page.dart';
import '../views/pages/tools_page.dart';
import '../core/analytics.dart';
import 'site_route.dart';

class SiteRouteInformationParser extends RouteInformationParser<SiteRoute> {
  const SiteRouteInformationParser();

  @override
  Future<SiteRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return SiteRoute.fromPath(routeInformation.uri.path);
  }

  @override
  RouteInformation restoreRouteInformation(SiteRoute configuration) {
    return RouteInformation(uri: Uri.parse(configuration.path));
  }
}

class SiteRouterDelegate extends RouterDelegate<SiteRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<SiteRoute> {
  SiteRoute _currentRoute = SiteRoute.home;
  String? _trackedPath;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  SiteRoute get currentConfiguration => _currentRoute;

  void go(SiteRoute route) {
    if (_currentRoute == route) {
      return;
    }

    _currentRoute = route;
    _trackCurrentRoute();
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(SiteRoute configuration) async {
    _currentRoute = configuration;
    _trackCurrentRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        _AnimatedRoutePage(
          key: ValueKey(_currentRoute.path),
          name: _currentRoute.path,
          child: _pageFor(_currentRoute),
        ),
      ],
      onDidRemovePage: (_) {
        if (_currentRoute != SiteRoute.home) {
          _currentRoute = SiteRoute.home;
          notifyListeners();
        }
      },
    );
  }

  Widget _pageFor(SiteRoute route) {
    return switch (route.kind) {
      SiteRouteKind.home => const HomePage(),
      SiteRouteKind.products => const ProductsPage(),
      SiteRouteKind.productDetail => ProductDetailPage(slug: route.slug!),
      SiteRouteKind.packages => const PackagesPage(),
      SiteRouteKind.packageDetail => PackageDetailPage(slug: route.slug!),
      SiteRouteKind.tools => const ToolsPage(),
      SiteRouteKind.ipAddress => const IpAddressPage(),
      SiteRouteKind.jsonParser => const JsonParserPage(),
      SiteRouteKind.qrCodeGenerator => const QrCodeGeneratorPage(),
      SiteRouteKind.articles => const ArticlesPage(),
      SiteRouteKind.articleDetail => ArticleDetailPage(slug: route.slug!),
      SiteRouteKind.about => const AboutPage(),
      SiteRouteKind.privacy => const PrivacyPage(),
      SiteRouteKind.notFound => const NotFoundPage(),
    };
  }

  void _trackCurrentRoute() {
    if (_trackedPath == _currentRoute.path) {
      return;
    }

    _trackedPath = _currentRoute.path;
    Analytics.logPageView(path: _currentRoute.path, title: _currentRoute.label);
  }
}

class _AnimatedRoutePage extends Page<void> {
  const _AnimatedRoutePage({
    required super.key,
    required super.name,
    required this.child,
  });

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) {
    return PageRouteBuilder<void>(
      settings: this,
      pageBuilder: (_, _, _) => child,
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
}
