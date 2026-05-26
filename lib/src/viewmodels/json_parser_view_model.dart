// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      _saveBytesAsPng(bytes, 'json-block-visualization.png');
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }

  void _scheduleParse() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), _parse);
  }

  void _parse() {
    try {
      final input = controller.text.trim();
      parsed = input.isEmpty ? null : jsonDecode(input);
      error = null;
    } on FormatException catch (parseError) {
      parsed = null;
      error = '${parseError.message} at character ${parseError.offset ?? '-'}';
    } on Object catch (parseError) {
      parsed = null;
      error = parseError.toString();
    }
    notifyListeners();
  }

  void _saveBytesAsPng(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes], 'image/png');
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
