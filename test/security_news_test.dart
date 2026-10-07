import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aqoong_homepage/src/data/security_articles.dart';
import 'package:aqoong_homepage/src/routes/site_route.dart';
import 'package:aqoong_homepage/src/routes/site_router.dart';

class FeedBundle extends CachingAssetBundle {
  FeedBundle(this.content);
  final String content;
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(content)));
}

Map<String, dynamic> story() => {
  'schemaVersion': 1,
  'slug': 'test-story',
  'revision': 'a' * 64,
  'title': '합성 테스트 뉴스',
  'summary': '공식 사실 요약 테스트',
  'identifiers': ['CVE-2026-900001'],
  'affected': ['example <1.1'],
  'exploitation': '악용 근거 확인 필요',
  'actions': ['공식 수정 버전 미확인'],
  'sources': [
    {
      'title': '공식 테스트 출처',
      'url': 'https://github.com/advisories/GHSA-2345-6789-cfgh',
    },
  ],
  'publishedAt': null,
  'updatedAt': '2026-10-06T00:00:00Z',
  'corrections': [],
};
void main() {
  test(
    'reader validates schema and source URLs; tutorial routing remains intact',
    () async {
      expect(
        (await loadSecurityArticles(
          FeedBundle(
            jsonEncode({
              'schemaVersion': 1,
              'articles': [story()],
            }),
          ),
        )).single.slug,
        'test-story',
      );
      await expectLater(
        loadSecurityArticles(FeedBundle('{"schemaVersion":2,"articles":[]}')),
        throwsFormatException,
      );
      final invalid = story();
      invalid['sources'] = [
        {'title': 'Unsafe', 'url': 'javascript:alert(1)'},
      ];
      await expectLater(
        loadSecurityArticles(
          FeedBundle(
            jsonEncode({
              'schemaVersion': 1,
              'articles': [invalid],
            }),
          ),
        ),
        throwsFormatException,
      );
      expect(SiteRoute.fromPath('/security').isArticlesSection, true);
      expect(SiteRoute.fromPath('/security/test-story').slug, 'test-story');
      expect(
        SiteRoute.fromPath('/articles/flutter-ripple-effect').kind,
        SiteRouteKind.articleDetail,
      );
    },
  );
  testWidgets('empty, error, list and unknown detail states are visible', (
    tester,
  ) async {
    Future<void> show(String feed, {String? slug}) async {
      final bundle = FeedBundle(feed);
      final delegate = SiteRouterDelegate()
        ..go(
          slug == null ? SiteRoute.security : SiteRoute.securityDetail(slug),
        );
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: bundle,
          child: MaterialApp.router(routerDelegate: delegate),
        ),
      );
      await tester.pumpAndSettle();
    }

    await show('{"schemaVersion":1,"articles":[]}');
    expect(find.text('아직 게시된 보안 소식이 없습니다.'), findsOneWidget);
    await show('malformed');
    expect(find.text('보안 소식을 불러오지 못했습니다.'), findsOneWidget);
    await show(
      jsonEncode({
        'schemaVersion': 1,
        'articles': [story()],
      }),
    );
    expect(find.text('합성 테스트 뉴스'), findsOneWidget);
    await tester.tap(find.text('읽기'));
    await tester.pumpAndSettle();
    expect(find.text('공식 사실 요약 테스트'), findsWidgets);
    for (final size in [const Size(390, 844), const Size(1440, 900)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('공식 테스트 출처'));
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, '공식 테스트 출처'))
            .onPressed,
        isNotNull,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      expect(FocusManager.instance.primaryFocus, isNotNull);
      expect(tester.takeException(), isNull);
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    await show(
      jsonEncode({
        'schemaVersion': 1,
        'articles': [story()],
      }),
      slug: 'unknown',
    );
    expect(find.text('보안 소식을 찾을 수 없습니다.'), findsOneWidget);
  });
}
