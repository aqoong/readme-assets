import 'package:flutter/material.dart';

import '../../routes/site_route.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';
import '../sections/ip_address_section.dart';

class IpAddressPage extends StatelessWidget {
  const IpAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      currentRoute: SiteRoute.ipAddress,
      children: [IpAddressSection(), FooterSection()],
    );
  }
}
