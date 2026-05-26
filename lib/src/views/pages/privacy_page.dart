import 'package:flutter/material.dart';

import '../../routes/site_route.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';
import '../sections/privacy_section.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      currentRoute: SiteRoute.privacy,
      children: [PrivacySection(), FooterSection()],
    );
  }
}
