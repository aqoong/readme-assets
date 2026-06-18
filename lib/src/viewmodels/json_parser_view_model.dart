// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../utils/json_tools.dart';

class JsonParserViewModel extends ChangeNotifier {
  JsonParserViewModel() {
    controller.addListener(_scheduleParse);
    _parse();
  }

  final controller = TextEditingController(text: _sampleJson);
  final captureKey = GlobalKey();

  Object? parsed;
  String? error;
  bool isDownloading = false;

  Timer? _debounce;
  static const maxInputLength = 240000;

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  Future<void> downloadPng() async {
    if (parsed == null || isDownloading) {
      return;
    }

    isDownloading = true;
    notifyListeners();
    try {
      final boundary =
          captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        return;
      }

      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return;
      }

      final bytes = byteData.buffer.asUint8List();
      _saveBytes(bytes, 'json-block-visualization.png', 'image/png');
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  void prettyPrint() {
    if (parsed == null || error != null) {
      _parse();
      if (parsed == null || error != null) {
        return;
      }
    }
    controller.text = prettyPrintJson(parsed);
  }

  void minify() {
    if (parsed == null || error != null) {
      _parse();
      if (parsed == null || error != null) {
        return;
      }
    }
    controller.text = minifyJson(parsed);
  }

  void clear() {
    controller.clear();
  }

  void loadSample() {
    controller.text = _sampleJson.trim();
  }

  void downloadJson() {
    if (parsed == null || error != null) {
      return;
    }
    final bytes = Uint8List.fromList(utf8.encode(prettyPrintJson(parsed)));
    _saveBytes(bytes, 'formatted-json.json', 'application/json');
  }

  void _scheduleParse() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), _parse);
  }

  void _parse() {
    final input = controller.text;
    if (input.length > maxInputLength) {
      parsed = null;
      error =
          'Input is too large for the browser preview. Keep it under $maxInputLength characters.';
      notifyListeners();
      return;
    }
    final result = parseJsonInput(input);
    parsed = result.value;
    error = result.error;
    notifyListeners();
  }

  void _saveBytes(Uint8List bytes, String fileName, String mimeType) {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }
}

const _sampleJson = '''
{
  "site": "AQoong.dev",
  "purpose": ["Flutter packages", "Android libraries", "JSON parser"],
  "adsenseReady": true,
  "packageCount": 11,
  "examples": {
    "api": "response analysis",
    "firebase": null
  }
}
''';
