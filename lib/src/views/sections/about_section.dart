// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'package:flutter/material.dart';

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
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => html.window.open(
                        'https://github.com/aqoong',
                        '_blank',
                      ),
                      icon: const Icon(Icons.code),
                      label: const Text('GitHub'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => html.window.open(
                        'https://owly-expbook.tistory.com',
                        '_blank',
                      ),
                      icon: const Icon(Icons.article_outlined),
                      label: const Text('Tech Blog'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => html.window.location.href =
                          'mailto:cooldnjsdn@gmail.com',
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
