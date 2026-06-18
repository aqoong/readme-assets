import 'dart:convert';

class JsonToolResult {
  const JsonToolResult.valid(this.value) : error = null;
  const JsonToolResult.invalid(this.error) : value = null;

  final Object? value;
  final String? error;

  bool get isValid => error == null;
}

JsonToolResult parseJsonInput(String input) {
  try {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const JsonToolResult.valid(null);
    }
    return JsonToolResult.valid(jsonDecode(trimmed));
  } on FormatException catch (error) {
    return JsonToolResult.invalid(
      '${error.message} at character ${error.offset ?? '-'}',
    );
  } on Object catch (error) {
    return JsonToolResult.invalid(error.toString());
  }
}

String prettyPrintJson(Object? value) {
  return const JsonEncoder.withIndent('  ').convert(value);
}

String minifyJson(Object? value) {
  return jsonEncode(value);
}
