import 'package:aqoong_homepage/package_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('looks up package by slug', () {
    final package = packageBySlug('ripple-container');

    expect(package, isNotNull);
    expect(package!.name, 'ripple_container');
    expect(package.platform, 'Flutter');
  });

  test('returns null for unknown slug', () {
    expect(packageBySlug('unknown-package'), isNull);
  });
}
