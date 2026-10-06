import 'package:flutter/material.dart';
import '../../data/security_articles.dart';
import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../utils/open_url.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';

class SecurityNewsPage extends StatefulWidget {
  const SecurityNewsPage({super.key, this.slug});
  final String? slug;
  @override
  State<SecurityNewsPage> createState() => _SecurityNewsPageState();
}

class _SecurityNewsPageState extends State<SecurityNewsPage> {
  AssetBundle? _bundle;
  Future<List<SecurityArticle>>? _articles;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bundle = DefaultAssetBundle.of(context);
    if (_bundle != bundle) {
      _bundle = bundle;
      _articles = loadSecurityArticles(bundle);
    }
  }

  @override
  Widget build(BuildContext context) => PageScaffold(
    currentRoute: widget.slug == null
        ? SiteRoute.security
        : SiteRoute.securityDetail(widget.slug!),
    children: [
      SectionBand(
        backgroundColor: const Color(0xFFF8FAFC),
        child: ConstrainedSection(
          id: 'security',
          title: '보안 소식',
          subtitle: '공식 공개 권고와 대응 정보를 확인하세요. 개인 프로젝트의 검사 결과는 공개하지 않습니다.',
          child: FutureBuilder<List<SecurityArticle>>(
            future: _articles,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('보안 소식을 불러오지 못했습니다.');
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final articles = snapshot.data!;
              if (widget.slug != null) {
                final matching = articles.where((a) => a.slug == widget.slug);
                if (matching.isEmpty) return const Text('보안 소식을 찾을 수 없습니다.');
                return _detail(context, matching.first);
              }
              if (articles.isEmpty) return const Text('아직 게시된 보안 소식이 없습니다.');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: articles
                    .map(
                      (a) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 12),
                              Text(a.summary),
                              const SizedBox(height: 12),
                              Text('갱신 ${a.updatedAt.substring(0, 10)}'),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () => goToRoute(
                                  context,
                                  SiteRoute.securityDetail(a.slug),
                                ),
                                child: const Text('읽기'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
      const FooterSection(),
    ],
  );
  Widget _detail(BuildContext context, SecurityArticle article) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton(
        onPressed: () => goToRoute(context, SiteRoute.security),
        child: const Text('보안 소식 목록'),
      ),
      Text(article.title, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 16),
      Text(article.summary),
      const SizedBox(height: 16),
      Text(article.values('identifiers').join(' · ')),
      Text('갱신 ${article.updatedAt}'),
      const SizedBox(height: 20),
      Text('영향 범위', style: Theme.of(context).textTheme.titleLarge),
      if (article.values('affected').isEmpty)
        const Text('자세한 제품·버전 범위는 공식 원문을 확인하세요.'),
      ...article
          .values('affected')
          .map(
            (v) =>
                Padding(padding: const EdgeInsets.only(top: 8), child: Text(v)),
          ),
      const SizedBox(height: 20),
      Text(article.data['exploitation'] as String),
      const SizedBox(height: 20),
      Text('대응 정보', style: Theme.of(context).textTheme.titleLarge),
      ...article
          .values('actions')
          .map(
            (v) =>
                Padding(padding: const EdgeInsets.only(top: 8), child: Text(v)),
          ),
      const SizedBox(height: 20),
      ...(article.data['corrections'] as List).map(
        (v) => Text('정정 ${v['at']}: ${v['text']}'),
      ),
      const SizedBox(height: 20),
      Text('공식 출처', style: Theme.of(context).textTheme.titleLarge),
      ...(article.data['sources'] as List).map(
        (v) => TextButton(
          onPressed: () => openExternalUrl(v['url'] as String),
          child: Text(v['title'] as String),
        ),
      ),
    ],
  );
}
