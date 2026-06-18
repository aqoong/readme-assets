import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_widgets.dart';

class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.code, this.title});

  final String code;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final trimmed = code.trim();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy code',
                    onPressed: () => _copy(context, trimmed),
                    color: Colors.white,
                    icon: const Icon(Icons.copy_all, size: 18),
                  ),
                ],
              ),
            )
          else
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                tooltip: 'Copy code',
                onPressed: () => _copy(context, trimmed),
                color: Colors.white,
                icon: const Icon(Icons.copy_all, size: 18),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(
              trimmed,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Code copied')));
    }
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.title,
    this.body,
    this.items = const [],
  });

  final String title;
  final String? body;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          if (body != null) ...[
            const SizedBox(height: 8),
            Text(
              body!,
              style: const TextStyle(color: Color(0xFF475569), height: 1.65),
            ),
          ],
          if (items.isNotEmpty) ...[
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('- ', style: TextStyle(height: 1.55)),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Color(0xFF475569),
                              height: 1.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class TagWrap extends StatelessWidget {
  const TagWrap({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final item in items) Tag(label: item)],
    );
  }
}
