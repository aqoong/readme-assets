import 'package:flutter/material.dart';

import '../../routes/site_route.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';
import '../sections/guide_section.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      currentRoute: SiteRoute.guide,
      children: [GuideSection(), FooterSection()],
    );
  }
}
