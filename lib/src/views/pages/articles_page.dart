import 'package:flutter/material.dart';

import '../../data/article_catalog.dart';
import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      currentRoute: SiteRoute.articles,
      children: [
        SectionBand(
          backgroundColor: const Color(0xFFF8FAFC),
          child: ConstrainedSection(
            id: 'articles',
            title: 'Developer Articles',
            subtitle:
                'Problem-solving notes for Flutter UI, Android custom views, and the AQoong open-source packages behind them.',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: articles.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (context, index) {
                    return _ArticleCard(article: articles[index]);
                  },
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

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final ArticleInfo article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                article.summary,
                style: const TextStyle(color: Color(0xFF475569), height: 1.55),
              ),
            ),
            Text(
              'Updated ${article.lastUpdated}',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () =>
                  goToRoute(context, SiteRoute.articleDetail(article.slug)),
              icon: const Icon(Icons.article_outlined),
              label: const Text('Read article'),
            ),
          ],
        ),
      ),
    );
  }
}
