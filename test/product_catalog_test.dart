import 'package:aqoong_homepage/src/data/product_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Famitree exposes only the current Web service', () {
    final famitree = productBySlug('famitree');

    expect(famitree, isNotNull);
    expect(famitree!.platforms, ['Web']);
    expect(famitree.serviceUrl, 'https://famitree.aqoong.pe.kr/');
  });
}
