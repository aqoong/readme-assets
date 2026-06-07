enum SiteRoute {
  home('/', 'Home'),
  packages('/packages', 'Packages'),
  jsonParser('/json-parser', 'JSON Parser'),
  guide('/guide', 'Guide'),
  about('/about', 'About'),
  privacy('/privacy', 'Privacy');

  const SiteRoute(this.path, this.label);

  final String path;
  final String label;

  static SiteRoute fromPath(String? path) {
    final normalized = _normalizePath(path);

    return SiteRoute.values.firstWhere(
      (route) => route.path == normalized,
      orElse: () => SiteRoute.home,
    );
  }

  static String _normalizePath(String? path) {
    if (path == null || path.isEmpty) {
      return SiteRoute.home.path;
    }
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }
}
