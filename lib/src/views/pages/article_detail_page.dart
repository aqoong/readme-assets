import 'package:flutter/material.dart';

import '../../../package_catalog.dart';
import '../../data/article_catalog.dart';
import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/content_widgets.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final article = articleBySlug(slug);
    if (article == null) {
      return const PageScaffold(
        currentRoute: SiteRoute.notFound,
        children: [_MissingArticleSection(), FooterSection()],
      );
    }

    final relatedPackages = article.relatedPackageSlugs
        .map(packageBySlug)
        .whereType<PackageInfo>()
        .toList();

    return PageScaffold(
      currentRoute: SiteRoute.articleDetail(article.slug),
      children: [
        SectionBand(
          child: ConstrainedSection(
            id: 'article-${article.slug}',
            title: article.title,
            subtitle: article.summary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TagWrap(
                  items: [
                    'Tutorial',
                    'Updated ${article.lastUpdated}',
                    for (final package in relatedPackages) package.name,
                  ],
                ),
                const SizedBox(height: 18),
                ContentCard(
                  children: [
                    const _TableOfContents(),
                    TextSection(title: 'Problem', body: article.problem),
                    TextSection(
                      title: 'Implementation principles',
                      items: article.principles,
                    ),
                    TextSection(
                      title: 'Code example',
                      body:
                          'Use this as a starting point and verify package versions before copying into a production app.',
                    ),
                    CodeBlock(title: article.codeTitle, code: article.code),
                    const SizedBox(height: 22),
                    TextSection(
                      title: 'Using the package',
                      body: article.packageUsage,
                    ),
                    TextSection(title: 'Cautions', items: article.cautions),
                    _FaqList(items: article.faq),
                    _RelatedLinks(
                      article: article,
                      relatedPackages: relatedPackages,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const FooterSection(),
      ],
    );
  }
}

class _TableOfContents extends StatelessWidget {
  const _TableOfContents();

  @override
  Widget build(BuildContext context) {
    return const TextSection(
      title: 'Contents',
      items: [
        'Problem',
        'Implementation principles',
        'Code example',
        'Using the package',
        'Cautions',
        'FAQ',
        'Related content',
      ],
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({required this.items});

  final List<FaqItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FAQ',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                item.question,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      item.answer,
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _RelatedLinks extends StatelessWidget {
  const _RelatedLinks({required this.article, required this.relatedPackages});

  final ArticleInfo article;
  final List<PackageInfo> relatedPackages;

  @override
  Widget build(BuildContext context) {
    final currentIndex = articles.indexWhere(
      (item) => item.slug == article.slug,
    );
    final previous = currentIndex > 0 ? articles[currentIndex - 1] : null;
    final next = currentIndex >= 0 && currentIndex < articles.length - 1
        ? articles[currentIndex + 1]
        : null;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        TextButton.icon(
          onPressed: () => goToRoute(context, SiteRoute.articles),
          icon: const Icon(Icons.arrow_back),
          label: const Text('All articles'),
        ),
        if (previous != null)
          OutlinedButton(
            onPressed: () =>
                goToRoute(context, SiteRoute.articleDetail(previous.slug)),
            child: Text(previous.title),
          ),
        if (next != null)
          OutlinedButton(
            onPressed: () =>
                goToRoute(context, SiteRoute.articleDetail(next.slug)),
            child: Text(next.title),
          ),
        for (final package in relatedPackages)
          FilledButton.tonal(
            onPressed: () =>
                goToRoute(context, SiteRoute.packageDetail(package.slug)),
            child: Text(package.name),
          ),
      ],
    );
  }
}

class _MissingArticleSection extends StatelessWidget {
  const _MissingArticleSection();

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      child: ConstrainedSection(
        id: 'missing-article',
        title: 'Article not found',
        subtitle: 'The requested article slug is not available.',
        child: SizedBox.shrink(),
      ),
    );
  }
}
