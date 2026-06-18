import 'package:aqoong_homepage/src/utils/json_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pretty prints JSON', () {
    final result = parseJsonInput('{"name":"AQoong","items":[1,true,null]}');

    expect(result.isValid, isTrue);
    expect(
      prettyPrintJson(result.value),
      contains('  "items": [\n    1,\n    true,\n    null\n  ]'),
    );
  });

  test('minifies JSON', () {
    final result = parseJsonInput('{\n  "name": "AQoong"\n}');

    expect(result.isValid, isTrue);
    expect(minifyJson(result.value), '{"name":"AQoong"}');
  });

  test('reports invalid JSON', () {
    final result = parseJsonInput('{"name": }');

    expect(result.isValid, isFalse);
    expect(result.error, contains('character'));
  });
}
