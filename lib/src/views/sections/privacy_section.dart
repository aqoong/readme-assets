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
                  title: 'Site logs and cookies',
                  body:
                      'This static site does not ask visitors to create an account or submit personal profile data. Hosting, browser, analytics, or advertising providers may process basic logs, device information, and cookies according to their own policies.',
                ),
                _PolicyItem(
                  title: 'Google AdSense',
                  body:
                      'This site may use Google AdSense. Google and its partners may use advertising cookies to serve or measure ads. Visitors can manage personalized advertising through Google Ads Settings and browser cookie controls.',
                ),
                _PolicyItem(
                  title: 'JSON Parser data',
                  body:
                      'JSON pasted into the JSON Parser is processed in the client browser for validation, formatting, minifying, copying, and visualization. The tool is designed not to send the entered JSON to a server, but visitors should still avoid pasting secrets or private customer data into browser tools.',
                ),
                _PolicyItem(
                  title: 'External links',
                  body:
                      'Pages link to GitHub, pub.dev, a technical blog, and other developer resources. External websites have their own privacy policies and content practices.',
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
