import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

class Analytics {
  const Analytics._();

  static void initialize() {
    if (!_isAvailable) {
      return;
    }

    unawaited(FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true));
  }

  static void logPageView({required String path, required String title}) {
    if (!_isAvailable) {
      return;
    }

    unawaited(
      FirebaseAnalytics.instance.logEvent(
        name: 'page_view',
        parameters: {
          'page_title': title,
          'page_path': path,
          'page_location': Uri.base.resolve(path).toString(),
        },
      ),
    );
  }

  static bool get _isAvailable {
    return DefaultFirebaseOptions.isConfigured && Firebase.apps.isNotEmpty;
  }
}
