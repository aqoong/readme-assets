import 'dart:convert';
import 'package:flutter/services.dart';

class SecurityArticle {
  SecurityArticle(this.data);
  final Map<String, dynamic> data;
  String get slug => data['slug'] as String;
  String get title => data['title'] as String;
  String get summary => data['summary'] as String;
  String get updatedAt => data['updatedAt'] as String;
  List<String> values(String key) => List<String>.from(data[key] as List);
}

Future<List<SecurityArticle>> loadSecurityArticles(AssetBundle bundle) async {
  try {
    final feed =
        jsonDecode(await bundle.loadString('assets/security/articles.json'))
            as Map<String, dynamic>;
    if (feed['schemaVersion'] != 1 ||
        feed.keys.any((k) => !['schemaVersion', 'articles'].contains(k))) {
      throw const FormatException();
    }
    final articles = <SecurityArticle>[];
    final slugs = <String>{};
    for (final raw in feed['articles'] as List) {
      final article = Map<String, dynamic>.from(raw as Map);
      const fields = [
        'schemaVersion',
        'slug',
        'revision',
        'title',
        'summary',
        'identifiers',
        'affected',
        'exploitation',
        'actions',
        'sources',
        'publishedAt',
        'updatedAt',
        'corrections',
      ];
      if (article.length != fields.length ||
          article.keys.any((k) => !fields.contains(k)) ||
          article['schemaVersion'] != 1) {
        throw const FormatException();
      }
      for (final key in [
        'slug',
        'revision',
        'title',
        'summary',
        'exploitation',
        'updatedAt',
      ]) {
        if (article[key] is! String || (article[key] as String).isEmpty) {
          throw const FormatException();
        }
      }
      if (!RegExp(r'^[a-z0-9][a-z0-9-]{0,100}$').hasMatch(article['slug']) ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch(article['revision']) ||
          !slugs.add(article['slug'])) {
        throw const FormatException();
      }
      DateTime.parse(article['updatedAt']);
      if (article['publishedAt'] != null) {
        DateTime.parse(article['publishedAt'] as String);
      }
      for (final key in ['identifiers', 'affected', 'actions']) {
        List<String>.from(article[key] as List);
      }
      final sources = article['sources'] as List;
      if (sources.isEmpty) throw const FormatException();
      for (final source in sources) {
        final link = source as Map;
        if (link.length != 2 ||
            link['title'] is! String ||
            link['url'] is! String) {
          throw const FormatException();
        }
        final uri = Uri.parse(link['url'] as String);
        const hosts = [
          'github.com',
          'www.boho.or.kr',
          'boho.or.kr',
          'www.krcert.or.kr',
          'krcert.or.kr',
          'www.cisa.gov',
          'cisa.gov',
          'osv.dev',
        ];
        if (uri.scheme != 'https' ||
            uri.userInfo.isNotEmpty ||
            uri.hasPort ||
            !hosts.contains(uri.host) ||
            uri.host == 'github.com' && !uri.path.startsWith('/advisories/')) {
          throw const FormatException();
        }
      }
      for (final correction in article['corrections'] as List) {
        final item = correction as Map;
        if (item.length != 2 || item['text'] is! String) {
          throw const FormatException();
        }
        DateTime.parse(item['at'] as String);
      }
      articles.add(SecurityArticle(article));
    }
    articles.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return articles;
  } catch (_) {
    throw const FormatException('Invalid security feed');
  }
}
