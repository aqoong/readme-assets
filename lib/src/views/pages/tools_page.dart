import 'package:flutter/material.dart';

import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      currentRoute: SiteRoute.tools,
      children: [
        SectionBand(
          backgroundColor: const Color(0xFFEEF4FF),
          child: ConstrainedSection(
            id: 'tools',
            title: 'Developer Tools',
            subtitle:
                'Browser-only utilities for everyday API and Flutter development workflows.',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JSON Parser',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Validate, pretty print, minify, copy, download, and inspect nested JSON as typed blocks. Input is processed in the browser and is not sent to a server.',
                      style: TextStyle(color: Color(0xFF475569), height: 1.55),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => goToRoute(context, SiteRoute.jsonParser),
                      icon: const Icon(Icons.account_tree_outlined),
                      label: const Text('Open JSON Parser'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const FooterSection(),
      ],
    );
  }
}
