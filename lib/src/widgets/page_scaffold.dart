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
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SiteAppBar(currentRoute: currentRoute),
            SliverToBoxAdapter(child: Column(children: children)),
          ],
        ),
      ),
    );
  }
}
