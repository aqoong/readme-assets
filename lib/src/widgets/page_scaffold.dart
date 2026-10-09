import 'package:flutter/material.dart';

import '../routes/site_route.dart';
import 'site_app_bar.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.currentRoute,
    required this.children,
  });

  final SiteRoute currentRoute;

  /// Page sections followed by the footer as the last child.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SiteAppBar(currentRoute: currentRoute),
            if (children.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Column(
                  children: children.take(children.length - 1).toList(),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [children.last],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
