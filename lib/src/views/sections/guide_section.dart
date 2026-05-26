import 'package:flutter/material.dart';

import '../../widgets/common_widgets.dart';
import '../../widgets/content_grid.dart';

class GuideSection extends StatelessWidget {
  const GuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      child: ConstrainedSection(
        id: 'guide',
        title: 'Why Use a JSON Online Parser?',
        subtitle:
            'Readable JSON saves time when debugging APIs, reviewing app data, and writing technical documentation.',
        child: Column(
          children: [
            ContentGrid(
              items: [
                ContentItem(
                  icon: Icons.api,
                  title: 'API Response Analysis',
                  body:
                      'Inspect REST and GraphQL responses as typed blocks so objects, arrays, strings, numbers, booleans, and null values are easier to validate.',
                ),
                ContentItem(
                  icon: Icons.cloud_queue,
                  title: 'Firebase Data Checks',
                  body:
                      'Paste Firestore documents, Remote Config payloads, or Cloud Function responses and quickly find nested values during development.',
                ),
                ContentItem(
                  icon: Icons.description_outlined,
                  title: 'Developer Documentation',
                  body:
                      'Create PNG snapshots of JSON structures for README files, issue reports, API specs, and onboarding notes.',
                ),
              ],
            ),
            SizedBox(height: 18),
            _FeatureList(),
          ],
        ),
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    const features = [
      'Real-time parsing while editing JSON input',
      'Clear parse errors with character positions when available',
      'Separate visual labels for Object, Array, String, Number, Boolean, and Null',
      'Nested block rendering for complex API and Firebase payloads',
      'PNG export for documents, bug reports, and package READMEs',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Features',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            for (final feature in features)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Color(0xFF15803D),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
