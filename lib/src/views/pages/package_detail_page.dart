import 'package:flutter/material.dart';

import '../../../package_catalog.dart';
import '../../data/article_catalog.dart';
import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../utils/open_url.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/content_widgets.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';

class PackageDetailPage extends StatelessWidget {
  const PackageDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final package = packageBySlug(slug);
    if (package == null) {
      return const PageScaffold(
        currentRoute: SiteRoute.notFound,
        children: [_MissingPackageSection(), FooterSection()],
      );
    }

    final relatedPackages = relatedPackagesFor(package);
    final relatedArticles = package.relatedArticleSlugs
        .map(articleBySlug)
        .whereType<ArticleInfo>()
        .toList();

    return PageScaffold(
      currentRoute: SiteRoute.packageDetail(package.slug),
      children: [
        SectionBand(
          child: ConstrainedSection(
            id: 'package-${package.slug}',
            title: package.name,
            subtitle: package.description,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TagWrap(
                  items: [
                    package.platform,
                    ...package.tags,
                    if (package.version != null) package.version!,
                    'Updated ${package.lastUpdated}',
                  ],
                ),
                const SizedBox(height: 18),
                ContentCard(
                  children: [
                    TextSection(title: 'Solves', body: package.problem),
                    TextSection(title: 'Key features', items: package.features),
                    TextSection(
                      title: 'Installation',
                      body:
                          'Use the package manager instructions below. Android-only repositories may require checking the linked GitHub README for the latest Gradle setup.',
                    ),
                    CodeBlock(title: 'Install', code: package.installCode),
                    const SizedBox(height: 22),
                    TextSection(
                      title: 'Usage example',
                      body:
                          'The example focuses on the public usage pattern available from the project catalog. Confirm exact versions and APIs in pub.dev or GitHub before production use.',
                    ),
                    CodeBlock(title: 'Example', code: package.usageCode),
                    const SizedBox(height: 22),
                    if (package.parameters.isNotEmpty)
                      TextSection(
                        title: 'Important parameters',
                        items: [
                          for (final parameter in package.parameters)
                            '${parameter.name}: ${parameter.description}',
                        ],
                      ),
                    _LinkRow(package: package),
                  ],
                ),
                const SizedBox(height: 18),
                _RelatedContent(
                  package: package,
                  relatedPackages: relatedPackages,
                  relatedArticles: relatedArticles,
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

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.package});

  final PackageInfo package;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        OutlinedButton.icon(
          onPressed: () => openExternalUrl(package.githubUrl),
          icon: const Icon(Icons.code),
          label: const Text('GitHub'),
        ),
        if (package.pubDevUrl != null)
          OutlinedButton.icon(
            onPressed: () => openExternalUrl(package.pubDevUrl!),
            icon: const Icon(Icons.open_in_new),
            label: const Text('pub.dev'),
          ),
        if (package.documentationUrl != null)
          OutlinedButton.icon(
            onPressed: () => openExternalUrl(package.documentationUrl!),
            icon: const Icon(Icons.menu_book_outlined),
            label: const Text('Docs'),
          ),
        TextButton.icon(
          onPressed: () => goToRoute(context, SiteRoute.packages),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to packages'),
        ),
      ],
    );
  }
}

class _RelatedContent extends StatelessWidget {
  const _RelatedContent({
    required this.package,
    required this.relatedPackages,
    required this.relatedArticles,
  });

  final PackageInfo package;
  final List<PackageInfo> relatedPackages;
  final List<ArticleInfo> relatedArticles;

  @override
  Widget build(BuildContext context) {
    final currentIndex = packages.indexWhere(
      (item) => item.slug == package.slug,
    );
    final previous = currentIndex > 0 ? packages[currentIndex - 1] : null;
    final next = currentIndex >= 0 && currentIndex < packages.length - 1
        ? packages[currentIndex + 1]
        : null;

    return ContentCard(
      children: [
        Text(
          'Related content',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (previous != null)
              OutlinedButton.icon(
                onPressed: () =>
                    goToRoute(context, SiteRoute.packageDetail(previous.slug)),
                icon: const Icon(Icons.chevron_left),
                label: Text(previous.name),
              ),
            if (next != null)
              OutlinedButton.icon(
                onPressed: () =>
                    goToRoute(context, SiteRoute.packageDetail(next.slug)),
                icon: const Icon(Icons.chevron_right),
                label: Text(next.name),
              ),
            for (final related in relatedPackages)
              OutlinedButton(
                onPressed: () =>
                    goToRoute(context, SiteRoute.packageDetail(related.slug)),
                child: Text(related.name),
              ),
            for (final article in relatedArticles)
              FilledButton.tonal(
                onPressed: () =>
                    goToRoute(context, SiteRoute.articleDetail(article.slug)),
                child: Text(article.title),
              ),
          ],
        ),
      ],
    );
  }
}

class _MissingPackageSection extends StatelessWidget {
  const _MissingPackageSection();

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      child: ConstrainedSection(
        id: 'missing-package',
        title: 'Package not found',
        subtitle: 'The requested package slug is not in the current catalog.',
        child: SizedBox.shrink(),
      ),
    );
  }
}
