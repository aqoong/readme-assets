import 'package:flutter/material.dart';

import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/content_grid.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      backgroundColor: const Color(0xFF0F172A),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 860;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 24,
              vertical: isWide ? 86 : 56,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: isWide
                  ? const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _HeroCopy()),
                        SizedBox(width: 40),
                        Expanded(child: _HeroTerminal()),
                      ],
                    )
                  : const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroCopy(),
                        SizedBox(height: 32),
                        _HeroTerminal(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Pill(label: 'Flutter / Android Libraries'),
        const SizedBox(height: 24),
        Text(
          'AQoong.dev',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Developer portfolio and practical tools for Flutter, Android, and Dart workflows.',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFFCBD5E1),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => goToRoute(context, SiteRoute.jsonParser),
              icon: const Icon(Icons.data_object),
              label: const Text('Open JSON Parser'),
            ),
            OutlinedButton.icon(
              onPressed: () => goToRoute(context, SiteRoute.packages),
              icon: const Icon(Icons.widgets_outlined),
              label: const Text('Explore Packages'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroTerminal extends StatelessWidget {
  const _HeroTerminal();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF111827),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Color(0xFFE5E7EB),
            fontFamily: 'monospace',
            height: 1.55,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  _Dot(color: Color(0xFFEF4444)),
                  _Dot(color: Color(0xFFF59E0B)),
                  _Dot(color: Color(0xFF22C55E)),
                ],
              ),
              SizedBox(height: 18),
              Text(r'$ flutter pub add size_tailored_text'),
              Text(r'$ flutter pub add ripple_container'),
              Text(r'$ flutter pub add flutter_soft_keyboard'),
              Text(r'$ flutter pub add project_color_palette'),
              Text(r'$ dart run aqlinter'),
              SizedBox(height: 18),
              Text(
                '// Build readable developer tools and reusable Flutter packages.',
                style: TextStyle(color: Color(0xFF93C5FD)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 7),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class HomeSummarySection extends StatelessWidget {
  const HomeSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      child: ConstrainedSection(
        id: 'overview',
        title: 'Developer Resources',
        subtitle:
            'Jump into the package catalog, use the JSON parser, or read the workflow guide from dedicated indexable pages.',
        child: ContentGrid(
          items: [
            ContentItem(
              icon: Icons.widgets_outlined,
              title: 'Libraries & Packages',
              body:
                  'Browse Flutter packages and Android libraries with installation notes, usage examples, and links to pub.dev or GitHub.',
              route: SiteRoute.packages,
            ),
            ContentItem(
              icon: Icons.data_object,
              title: 'JSON Online Parser',
              body:
                  'Paste JSON and inspect API, Firebase, and config payloads as typed nested blocks with PNG export.',
              route: SiteRoute.jsonParser,
            ),
            ContentItem(
              icon: Icons.description_outlined,
              title: 'Developer Articles',
              body:
                  'Read practical Flutter and Android notes about custom keyboards, ripple effects, auto-sized text, and expandable text.',
              route: SiteRoute.articles,
            ),
          ],
        ),
      ),
    );
  }
}
