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
            child: LayoutBuilder(
              builder: (context, constraints) {
                const cards = [
                  _ToolCard(
                    title: 'JSON Parser',
                    description:
                        'Validate, pretty print, minify, copy, download, and inspect nested JSON as typed blocks.',
                    icon: Icons.account_tree_outlined,
                    buttonLabel: 'Open JSON Parser',
                    route: SiteRoute.jsonParser,
                  ),
                  _ToolCard(
                    title: 'QR Code Generator',
                    description:
                        'Create downloadable QR images for URLs, text, email, phone, SMS, contacts, locations, and Wi-Fi.',
                    icon: Icons.qr_code_2,
                    buttonLabel: 'Open QR Generator',
                    route: SiteRoute.qrCodeGenerator,
                  ),
                ];

                if (constraints.maxWidth >= 780) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 18),
                      Expanded(child: cards[1]),
                    ],
                  );
                }
                return Column(
                  children: [cards[0], const SizedBox(height: 18), cards[1]],
                );
              },
            ),
          ),
        ),
        const FooterSection(),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonLabel,
    required this.route,
  });

  final String title;
  final String description;
  final IconData icon;
  final String buttonLabel;
  final SiteRoute route;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '$description Input is processed in the browser and is not sent to a server.',
              style: const TextStyle(color: Color(0xFF475569), height: 1.55),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => goToRoute(context, route),
              icon: Icon(icon),
              label: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
