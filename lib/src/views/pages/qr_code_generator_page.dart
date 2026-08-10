import 'package:flutter/material.dart';

import '../../routes/site_route.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';
import '../sections/qr_code_generator_section.dart';

class QrCodeGeneratorPage extends StatelessWidget {
  const QrCodeGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      currentRoute: SiteRoute.qrCodeGenerator,
      children: [QrCodeGeneratorSection(), FooterSection()],
    );
  }
}
