import 'package:flutter/material.dart';

import '../../routes/site_route.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/about_section.dart';
import '../sections/footer_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      currentRoute: SiteRoute.about,
      children: [AboutSection(), FooterSection()],
    );
  }
}
