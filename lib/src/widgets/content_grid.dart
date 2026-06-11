import 'package:flutter/material.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

import '../routes/navigation.dart';
import '../routes/site_route.dart';

class ContentGrid extends StatelessWidget {
  const ContentGrid({super.key, required this.items});

  final List<ContentItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                items[index],
                if (index != items.length - 1) const SizedBox(height: 16),
              ],
            ],
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) => items[index],
        );
      },
    );
  }
}

class ContentItem extends StatelessWidget {
  const ContentItem({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.route,
  });

  final IconData icon;
  final String title;
  final String body;
  final SiteRoute? route;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 14),
            SizedBox(
              height: 24,
              child: SizeTailoredTextWidget(
                title,
                maxLines: 1,
                minFontSize: 13,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              maxLines: route == null ? 6 : 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF475569), height: 1.45),
            ),
            if (route != null) ...[
              const SizedBox(height: 14),
              TextButton.icon(
                onPressed: () => goToRoute(context, route!),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text('Open ${route!.label}'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
