import '../../package_catalog.dart';
import '../data/article_catalog.dart';

abstract final class SitePaths {
  static const home = '/';
  static const packages = '/packages';
  static const tools = '/tools';
  static const jsonParser = '/tools/json-parser';
  static const articles = '/articles';
  static const about = '/about';
  static const privacy = '/privacy';

  static String packageDetail(String slug) => '$packages/$slug';
  static String articleDetail(String slug) => '$articles/$slug';
}

enum SiteRouteKind {
  home,
  packages,
  packageDetail,
  tools,
  jsonParser,
  articles,
  articleDetail,
  about,
  privacy,
  notFound,
}

class SiteRoute {
  const SiteRoute._(this.kind, this.path, this.label, {this.slug});

  static const home = SiteRoute._(SiteRouteKind.home, SitePaths.home, 'Home');
  static const packages = SiteRoute._(
    SiteRouteKind.packages,
    SitePaths.packages,
    'Packages',
  );
  static const tools = SiteRoute._(
    SiteRouteKind.tools,
    SitePaths.tools,
    'Tools',
  );
  static const jsonParser = SiteRoute._(
    SiteRouteKind.jsonParser,
    SitePaths.jsonParser,
    'JSON Parser',
  );
  static const articles = SiteRoute._(
    SiteRouteKind.articles,
    SitePaths.articles,
    'Articles',
  );
  static const about = SiteRoute._(
    SiteRouteKind.about,
    SitePaths.about,
    'About',
  );
  static const privacy = SiteRoute._(
    SiteRouteKind.privacy,
    SitePaths.privacy,
    'Privacy',
  );
  static const notFound = SiteRoute._(
    SiteRouteKind.notFound,
    '/404',
    'Page not found',
  );

  factory SiteRoute.packageDetail(String slug) {
    final package = packageBySlug(slug);
    return SiteRoute._(
      SiteRouteKind.packageDetail,
      SitePaths.packageDetail(slug),
      package?.name ?? slug,
      slug: slug,
    );
  }

  factory SiteRoute.articleDetail(String slug) {
    final article = articleBySlug(slug);
    return SiteRoute._(
      SiteRouteKind.articleDetail,
      SitePaths.articleDetail(slug),
      article?.title ?? slug,
      slug: slug,
    );
  }

  final SiteRouteKind kind;
  final String path;
  final String label;
  final String? slug;

  bool get isPackageSection {
    return kind == SiteRouteKind.packages ||
        kind == SiteRouteKind.packageDetail;
  }

  bool get isToolsSection {
    return kind == SiteRouteKind.tools || kind == SiteRouteKind.jsonParser;
  }

  bool get isArticlesSection {
    return kind == SiteRouteKind.articles ||
        kind == SiteRouteKind.articleDetail;
  }

  static SiteRoute fromPath(String? path) {
    final normalized = normalizePath(path);

    switch (normalized) {
      case SitePaths.home:
        return home;
      case SitePaths.packages:
        return packages;
      case SitePaths.tools:
        return tools;
      case SitePaths.jsonParser:
      case '/json-parser':
        return jsonParser;
      case SitePaths.articles:
      case '/guide':
        return articles;
      case SitePaths.about:
        return about;
      case SitePaths.privacy:
        return privacy;
    }

    final segments = Uri.parse(normalized).pathSegments;
    if (segments.length == 2 && segments.first == 'packages') {
      final slug = segments.last;
      return packageBySlug(slug) == null
          ? notFound
          : SiteRoute.packageDetail(slug);
    }
    if (segments.length == 2 && segments.first == 'articles') {
      final slug = segments.last;
      return articleBySlug(slug) == null
          ? notFound
          : SiteRoute.articleDetail(slug);
    }
    return notFound;
  }

  static String normalizePath(String? path) {
    if (path == null || path.isEmpty) {
      return SitePaths.home;
    }
    final uri = Uri.parse(path);
    var normalized = uri.path.isEmpty ? SitePaths.home : uri.path;
    if (normalized.length > 1 && normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  @override
  bool operator ==(Object other) {
    return other is SiteRoute && other.kind == kind && other.slug == slug;
  }

  @override
  int get hashCode => Object.hash(kind, slug);

  @override
  String toString() => 'SiteRoute($path)';
}
