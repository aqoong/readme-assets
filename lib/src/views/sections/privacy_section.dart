import 'package:flutter/material.dart';

import '../../widgets/common_widgets.dart';

class PrivacySection extends StatelessWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      child: ConstrainedSection(
        id: 'privacy',
        title: 'Privacy Policy',
        subtitle:
            'This website serves as a documentation and showcase site for open-source packages developed by AQoong.',
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PolicyItem(
                  title: 'Information We Collect',
                  body:
                      'This site does not directly collect personal information. Google AdSense may use cookies to show ads based on browsing history.',
                ),
                _PolicyItem(
                  title: 'Google AdSense',
                  body:
                      'Google may use cookies and web beacons to serve ads. Personalized advertising can be managed through Google Ads Settings.',
                ),
                _PolicyItem(
                  title: 'Analytics',
                  body:
                      'This site may use analytics to understand visitor behavior. Data is anonymous and aggregated.',
                ),
                _PolicyItem(
                  title: 'Contact',
                  body:
                      'For privacy-related questions, contact cooldnjsdn@gmail.com.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  const _PolicyItem({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(color: Color(0xFF475569), height: 1.55),
          ),
        ],
      ),
    );
  }
}
