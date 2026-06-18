import 'package:flutter/material.dart';

import '../../utils/open_url.dart';
import '../../widgets/common_widgets.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      backgroundColor: const Color(0xFFF8FAFC),
      child: ConstrainedSection(
        id: 'about',
        title: 'About AQoong',
        subtitle:
            'Android, iOS, and Flutter developer based in Korea, building open-source packages from production app needs.',
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'I build open-source packages to solve real problems encountered in production apps. The current catalog includes Flutter packages published on pub.dev and native Android custom views shared on GitHub.',
                  style: TextStyle(color: Color(0xFF475569), height: 1.6),
                ),
                const SizedBox(height: 14),
                const Text(
                  'The site exists to document those libraries, publish practical Flutter and Android notes, provide small developer tools such as the JSON Parser, and keep the projects discoverable from search engines and GitHub Pages.',
                  style: TextStyle(color: Color(0xFF475569), height: 1.6),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Only public project information from this repository, GitHub, pub.dev links, and the AQoong contact address is presented here. Personal biography details are intentionally kept limited.',
                  style: TextStyle(color: Color(0xFF475569), height: 1.6),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () =>
                          openExternalUrl('https://github.com/aqoong'),
                      icon: const Icon(Icons.code),
                      label: const Text('GitHub'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () =>
                          openExternalUrl('https://owly-expbook.tistory.com'),
                      icon: const Icon(Icons.article_outlined),
                      label: const Text('Tech Blog'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => openMailTo('cooldnjsdn@gmail.com'),
                      icon: const Icon(Icons.mail_outline),
                      label: const Text('Email'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
