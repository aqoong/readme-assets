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
}
