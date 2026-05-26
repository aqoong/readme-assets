import 'package:flutter/material.dart';

import '../../routes/site_route.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';
import '../sections/json_parser_section.dart';

class JsonParserPage extends StatelessWidget {
  const JsonParserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      currentRoute: SiteRoute.jsonParser,
      children: [JsonParserSection(), FooterSection()],
    );
  }
}
