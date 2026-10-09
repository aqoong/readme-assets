@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:aqoong_homepage/src/routes/site_route.dart';
import 'package:aqoong_homepage/src/views/sections/footer_section.dart';
import 'package:aqoong_homepage/src/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final size in [const Size(1280, 900), const Size(390, 844)]) {
    testWidgets('footer follows content or viewport bottom at $size', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      const contentKey = ValueKey('content');
      final footerFinder = find.byType(FooterSection, skipOffstage: false);

      for (final height in [100.0, 650.0, 1600.0, 100.0]) {
        await tester.pumpWidget(
          MaterialApp(
            home: PageScaffold(
              currentRoute: SiteRoute.home,
              children: [
                SizedBox(key: contentKey, height: height),
                const FooterSection(),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();
        final scrollable = tester.state<ScrollableState>(
          find.byType(Scrollable).first,
        );
        scrollable.position.jumpTo(0);
        await tester.pumpAndSettle();

        final content = tester.getRect(find.byKey(contentKey));
        final footer = tester.getRect(footerFinder);
        printOnFailure('viewport=$size content=$content footer=$footer');
        expect(content.height, height);
        expect(
          footer.bottom,
          closeTo(math.max(size.height, content.bottom + footer.height), 0.1),
        );
        expect(footer.top, greaterThanOrEqualTo(content.bottom));

        scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
        await tester.pumpAndSettle();
        expect(
          tester.getBottomLeft(footerFinder).dy,
          closeTo(size.height, 0.1),
        );
        expect(tester.takeException(), isNull);
      }
    });
  }
}
