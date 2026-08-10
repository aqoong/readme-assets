// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@JS('aqoongRequestAd')
external void _requestAd();

class AdSenseBanner extends StatefulWidget {
  const AdSenseBanner({
    super.key,
    required this.placement,
    this.adSlot = const String.fromEnvironment(
      'ADSENSE_TOOL_SLOT',
      defaultValue: defaultToolSlot,
    ),
  });

  static const clientId = 'ca-pub-2949723081387241';
  static const defaultToolSlot = '2597340767';

  final String placement;
  final String adSlot;

  @override
  State<AdSenseBanner> createState() => _AdSenseBannerState();
}

class _AdSenseBannerState extends State<AdSenseBanner> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'adsense-${widget.placement}-${identityHashCode(this)}';
    _ensureAdSenseBridge();
    if (widget.adSlot.isEmpty) {
      return;
    }

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      final wrapper = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.overflow = 'hidden';
      final ad = html.Element.tag('ins')
        ..classes.add('adsbygoogle')
        ..style.display = 'block'
        ..style.width = '100%'
        ..attributes['data-ad-client'] = AdSenseBanner.clientId
        ..attributes['data-ad-slot'] = widget.adSlot
        ..attributes['data-ad-format'] = 'auto'
        ..attributes['data-full-width-responsive'] = 'true';
      wrapper.children.add(ad);
      return wrapper;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      try {
        _requestAd();
      } on Object {
        // Ad blockers and local development can prevent the AdSense API call.
      }
    });
  }

  void _ensureAdSenseBridge() {
    const bridgeId = 'aqoong-adsense-bridge';
    if (html.document.getElementById(bridgeId) == null) {
      final bridge = html.ScriptElement()
        ..id = bridgeId
        ..text = '''
window.aqoongRequestAd = function () {
  (window.adsbygoogle = window.adsbygoogle || []).push({});
};
''';
      html.document.head?.children.add(bridge);
    }

    final existingLoader = html.document.querySelector(
      'script[src*="pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"]',
    );
    if (existingLoader != null) {
      return;
    }
    final loader = html.ScriptElement()
      ..async = true
      ..src =
          'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js'
          '?client=${AdSenseBanner.clientId}'
      ..crossOrigin = 'anonymous';
    html.document.head?.children.add(loader);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adSlot.isEmpty) {
      if (!kDebugMode) {
        return const SizedBox.shrink();
      }
      return Container(
        height: 96,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Text(
          'AdSense 광고 미리보기 · ADSENSE_TOOL_SLOT 설정 필요',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
      );
    }

    return Semantics(
      label: 'Advertisement',
      child: SizedBox(
        height: 112,
        width: double.infinity,
        child: HtmlElementView(viewType: _viewType),
      ),
    );
  }
}
