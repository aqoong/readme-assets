import 'package:aqoong_homepage/src/routes/site_route.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses static paths', () {
    expect(SiteRoute.fromPath('/'), SiteRoute.home);
    expect(SiteRoute.fromPath('/products'), SiteRoute.products);
    expect(SiteRoute.fromPath('/packages'), SiteRoute.packages);
    expect(SiteRoute.fromPath('/tools'), SiteRoute.tools);
    expect(SiteRoute.fromPath('/tools/json-parser'), SiteRoute.jsonParser);
    expect(SiteRoute.fromPath('/articles'), SiteRoute.articles);
    expect(SiteRoute.fromPath('/about'), SiteRoute.about);
    expect(SiteRoute.fromPath('/privacy'), SiteRoute.privacy);
  });

  test('parses package and article detail paths', () {
    expect(
      SiteRoute.fromPath('/products/famitree'),
      SiteRoute.productDetail('famitree'),
    );
    expect(
      SiteRoute.fromPath('/packages/flutter-soft-keyboard'),
      SiteRoute.packageDetail('flutter-soft-keyboard'),
    );
    expect(
      SiteRoute.fromPath('/articles/flutter-ripple-effect'),
      SiteRoute.articleDetail('flutter-ripple-effect'),
    );
  });

  test('restores route objects to URLs', () {
    expect(SiteRoute.productDetail('famitree').path, '/products/famitree');
    expect(SiteRoute.packageDetail('aqlinter').path, '/packages/aqlinter');
    expect(
      SiteRoute.articleDetail('flutter-auto-resize-text').path,
      '/articles/flutter-auto-resize-text',
    );
  });

  test('unknown paths become 404', () {
    expect(SiteRoute.fromPath('/missing'), SiteRoute.notFound);
    expect(SiteRoute.fromPath('/products/not-real'), SiteRoute.notFound);
    expect(SiteRoute.fromPath('/packages/not-real'), SiteRoute.notFound);
  });
}
