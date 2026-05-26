// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:aqoong_homepage/package_catalog.dart';

void main() {
  runApp(const AQoongApp());
}

class AQoongApp extends StatelessWidget {
  const AQoongApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF2563EB);

    return MaterialApp(
      title: 'AQoong.dev - Flutter & Android Developer Libraries',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        fontFamily: 'Arial',
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white.withValues(alpha: 0.94),
              surfaceTintColor: Colors.white,
              title: const Text(
                'AQoong.dev',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              actions: const [
                _NavLink(label: 'Packages', anchor: '#packages'),
                _NavLink(label: 'JSON Parser', anchor: '#json-parser'),
                _NavLink(label: 'Guide', anchor: '#guide'),
                _NavLink(label: 'About', anchor: '#about'),
                SizedBox(width: 16),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: const [
                  _HeroSection(),
                  _PackagesSection(),
                  JsonParserSection(),
                  _SeoContentSection(),
                  _AboutSection(),
                  _PrivacySection(),
                  _Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.anchor});

  final String label;
  final String anchor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        html.window.location.hash = anchor;
      },
      child: Text(label),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return _SectionBand(
      backgroundColor: const Color(0xFF0F172A),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 860;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 24,
              vertical: isWide ? 86 : 56,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: isWide
                  ? const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _HeroCopy()),
                        SizedBox(width: 40),
                        Expanded(child: _HeroTerminal()),
                      ],
                    )
                  : const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroCopy(),
                        SizedBox(height: 32),
                        _HeroTerminal(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Pill(label: 'Flutter / Android Libraries'),
        const SizedBox(height: 24),
        Text(
          'AQoong.dev',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Developer portfolio and practical tools for Flutter, Android, and Dart workflows.',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFFCBD5E1),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => html.window.location.hash = '#json-parser',
              icon: const Icon(Icons.data_object),
              label: const Text('Open JSON Parser'),
            ),
            OutlinedButton.icon(
              onPressed: () => html.window.location.hash = '#packages',
              icon: const Icon(Icons.widgets_outlined),
              label: const Text('Explore Packages'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroTerminal extends StatelessWidget {
  const _HeroTerminal();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF111827),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Color(0xFFE5E7EB),
            fontFamily: 'monospace',
            height: 1.55,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  _Dot(color: Color(0xFFEF4444)),
                  _Dot(color: Color(0xFFF59E0B)),
                  _Dot(color: Color(0xFF22C55E)),
                ],
              ),
              SizedBox(height: 18),
              Text(r'$ flutter pub add size_tailored_text'),
              Text(r'$ flutter pub add ripple_container'),
              Text(r'$ flutter pub add flutter_soft_keyboard'),
              Text(r'$ flutter pub add project_color_palette'),
              Text(r'$ dart run aqlinter'),
              SizedBox(height: 18),
              Text(
                '// Build readable developer tools and reusable Flutter packages.',
                style: TextStyle(color: Color(0xFF93C5FD)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 7),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _PackagesSection extends StatelessWidget {
  const _PackagesSection();

  @override
  Widget build(BuildContext context) {
    final flutterPackages = packagesByCategory('Flutter');
    final androidPackages = packagesByCategory('Android');

    return _SectionBand(
      key: const ValueKey('packages'),
      child: _ConstrainedSection(
        id: 'packages',
        title: 'Libraries & Packages',
        subtitle:
            '${flutterPackages.length} Flutter packages and ${androidPackages.length} Android libraries from the current aqoong.pe.kr package catalog.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PackageGroup(title: 'Flutter Packages', items: flutterPackages),
            const SizedBox(height: 34),
            _PackageGroup(title: 'Android Libraries', items: androidPackages),
            const SizedBox(height: 34),
            const _PackageDetailsSection(),
          ],
        ),
      ),
    );
  }
}

class _PackageGroup extends StatelessWidget {
  const _PackageGroup({required this.title, required this.items});

  final String title;
  final List<PackageInfo> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 980
                ? 3
                : constraints.maxWidth >= 680
                ? 2
                : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 326,
              ),
              itemBuilder: (context, index) {
                return _PackageCard(info: items[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

class _PackageDetailsSection extends StatelessWidget {
  const _PackageDetailsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flutter Package Details',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        Card(
          child: Column(
            children: [
              for (final detail in packageDetails)
                ExpansionTile(
                  title: Text(
                    detail.packageName,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text(
                    'Installation, usage, features, and parameters',
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  children: [
                    for (final section in detail.sections)
                      _DetailSectionView(section: section),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailSectionView extends StatelessWidget {
  const _DetailSectionView({required this.section});

  final DetailSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          if (section.body != null) ...[
            const SizedBox(height: 8),
            Text(
              section.body!,
              style: const TextStyle(color: Color(0xFF475569), height: 1.5),
            ),
          ],
          if (section.items.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final item in section.items) _Tag(label: item)],
            ),
          ],
          if (section.code != null) ...[
            const SizedBox(height: 10),
            _CodeBlock(code: section.code!),
          ],
          if (section.parameters.isNotEmpty) ...[
            const SizedBox(height: 10),
            _ParameterTable(parameters: section.parameters),
          ],
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code.trim(),
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontFamily: 'monospace',
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _ParameterTable extends StatelessWidget {
  const _ParameterTable({required this.parameters});

  final List<ParameterInfo> parameters;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.1),
        2: FlexColumnWidth(2.5),
      },
      border: TableBorder.all(color: const Color(0xFFE2E8F0)),
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
          children: [
            _TableCellText('Parameter', isHeader: true),
            _TableCellText('Type', isHeader: true),
            _TableCellText('Description', isHeader: true),
          ],
        ),
        for (final parameter in parameters)
          TableRow(
            children: [
              _TableCellText(
                parameter.required ? '${parameter.name} *' : parameter.name,
              ),
              _TableCellText(parameter.type),
              _TableCellText(parameter.description),
            ],
          ),
      ],
    );
  }
}

class _TableCellText extends StatelessWidget {
  const _TableCellText(this.text, {this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: isHeader ? null : 'monospace',
          fontSize: 12,
          color: const Color(0xFF334155),
          fontWeight: isHeader ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.info});

  final PackageInfo info;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              info.category == 'Android'
                  ? Icons.android_outlined
                  : Icons.flutter_dash_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              info.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              info.tagline,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _Tag(label: info.category),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                info.description,
                style: const TextStyle(color: Color(0xFF475569), height: 1.45),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final item in info.highlights) _Tag(label: item)],
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => html.window.open(info.url, '_blank'),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(info.linkLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class JsonParserSection extends StatefulWidget {
  const JsonParserSection({super.key});

  @override
  State<JsonParserSection> createState() => _JsonParserSectionState();
}

class _JsonParserSectionState extends State<JsonParserSection> {
  final _controller = TextEditingController(text: _sampleJson);
  final _captureKey = GlobalKey();
  Object? _parsed;
  String? _error;
  Timer? _debounce;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _parse();
    _controller.addListener(_scheduleParse);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleParse() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), _parse);
  }

  void _parse() {
    try {
      final input = _controller.text.trim();
      setState(() {
        _parsed = input.isEmpty ? null : jsonDecode(input);
        _error = null;
      });
    } on FormatException catch (error) {
      setState(() {
        _parsed = null;
        _error = '${error.message} at character ${error.offset ?? '-'}';
      });
    } on Object catch (error) {
      setState(() {
        _parsed = null;
        _error = error.toString();
      });
    }
  }

  Future<void> _downloadPng() async {
    if (_parsed == null || _isDownloading) {
      return;
    }

    setState(() => _isDownloading = true);
    try {
      final boundary =
          _captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        return;
      }

      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return;
      }

      final bytes = byteData.buffer.asUint8List();
      _saveBytesAsPng(bytes, 'json-block-visualization.png');
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  void _saveBytesAsPng(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return _SectionBand(
      backgroundColor: const Color(0xFFEEF4FF),
      child: _ConstrainedSection(
        id: 'json-parser',
        title: 'JSON Online Parser',
        subtitle:
            'Paste API responses, Firebase documents, config files, or docs examples and inspect them as typed nested blocks.',
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final editor = _JsonInputCard(
              controller: _controller,
              error: _error,
            );
            final preview = _JsonPreviewCard(
              captureKey: _captureKey,
              parsed: _parsed,
              error: _error,
              isDownloading: _isDownloading,
              onDownload: _downloadPng,
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: editor),
                  const SizedBox(width: 18),
                  Expanded(child: preview),
                ],
              );
            }

            return Column(
              children: [editor, const SizedBox(height: 18), preview],
            );
          },
        ),
      ),
    );
  }
}

class _JsonInputCard extends StatelessWidget {
  const _JsonInputCard({required this.controller, required this.error});

  final TextEditingController controller;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note),
                const SizedBox(width: 10),
                Text(
                  'JSON Input',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              minLines: 18,
              maxLines: 18,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.5,
                height: 1.42,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Paste JSON here...',
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: error == null
                  ? const _StatusLine(
                      key: ValueKey('valid'),
                      icon: Icons.check_circle,
                      color: Color(0xFF15803D),
                      label: 'Valid JSON',
                    )
                  : _StatusLine(
                      key: const ValueKey('invalid'),
                      icon: Icons.error,
                      color: const Color(0xFFB91C1C),
                      label: error!,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JsonPreviewCard extends StatelessWidget {
  const _JsonPreviewCard({
    required this.captureKey,
    required this.parsed,
    required this.error,
    required this.isDownloading,
    required this.onDownload,
  });

  final GlobalKey captureKey;
  final Object? parsed;
  final String? error;
  final bool isDownloading;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_tree_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Block Visualization',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: parsed == null || error != null || isDownloading
                      ? null
                      : onDownload,
                  icon: isDownloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: const Text('PNG'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RepaintBoundary(
              key: captureKey,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 450),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFDFF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: parsed == null
                    ? const _EmptyPreview()
                    : _JsonValueBlock(label: 'root', value: parsed, depth: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JsonValueBlock extends StatelessWidget {
  const _JsonValueBlock({
    required this.label,
    required this.value,
    required this.depth,
  });

  final String label;
  final Object? value;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final currentValue = value;
    final type = _jsonTypeOf(value);
    final color = _typeColor(type);
    final isComplex = currentValue is Map || currentValue is List;

    return Container(
      margin: EdgeInsets.only(left: depth == 0 ? 0 : 14, top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
              _TypeBadge(type: type, color: color),
              if (isComplex)
                Text(
                  _sizeLabel(currentValue),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (currentValue is Map<String, dynamic>)
            for (final entry in currentValue.entries)
              _JsonValueBlock(
                label: entry.key,
                value: entry.value,
                depth: depth + 1,
              )
          else if (currentValue is List)
            for (var index = 0; index < currentValue.length; index++)
              _JsonValueBlock(
                label: '[$index]',
                value: currentValue[index],
                depth: depth + 1,
              )
          else
            Text(
              _formatScalar(currentValue),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Color(0xFF0F172A),
              ),
            ),
        ],
      ),
    );
  }
}

class _SeoContentSection extends StatelessWidget {
  const _SeoContentSection();

  @override
  Widget build(BuildContext context) {
    return _SectionBand(
      child: _ConstrainedSection(
        id: 'guide',
        title: 'Why Use a JSON Online Parser?',
        subtitle:
            'Readable JSON saves time when debugging APIs, reviewing app data, and writing technical documentation.',
        child: Column(
          children: const [
            _ContentGrid(
              items: [
                _ContentItem(
                  icon: Icons.api,
                  title: 'API Response Analysis',
                  body:
                      'Inspect REST and GraphQL responses as typed blocks so objects, arrays, strings, numbers, booleans, and null values are easier to validate.',
                ),
                _ContentItem(
                  icon: Icons.cloud_queue,
                  title: 'Firebase Data Checks',
                  body:
                      'Paste Firestore documents, Remote Config payloads, or Cloud Function responses and quickly find nested values during development.',
                ),
                _ContentItem(
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

class _ContentGrid extends StatelessWidget {
  const _ContentGrid({required this.items});

  final List<_ContentItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900 ? 3 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 2.7 : 1.15,
          ),
          itemBuilder: (context, index) => items[index],
        );
      },
    );
  }
}

class _ContentItem extends StatelessWidget {
  const _ContentItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

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
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                body,
                style: const TextStyle(color: Color(0xFF475569), height: 1.45),
              ),
            ),
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

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return _SectionBand(
      backgroundColor: const Color(0xFFF8FAFC),
      child: _ConstrainedSection(
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

class _PrivacySection extends StatelessWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context) {
    return _SectionBand(
      child: _ConstrainedSection(
        id: 'privacy',
        title: 'Privacy Policy',
        subtitle:
            'This website serves as a documentation and showcase site for open-source packages developed by AQoong.',
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PolicyItem(
                  title: 'Information We Collect',
                  body:
                      'This site does not directly collect personal information. Google AdSense may use cookies to show ads based on browsing history.',
                ),
                _PolicyItem(
                  title: 'Google AdSense',
                  body:
                      'Google may use cookies and web beacons to serve ads. Personalized advertising can be managed through Google Ads Settings.',
                ),
                _PolicyItem(
                  title: 'Analytics',
                  body:
                      'This site may use analytics to understand visitor behavior. Data is anonymous and aggregated.',
                ),
                _PolicyItem(
                  title: 'Contact',
                  body:
                      'For privacy-related questions, contact cooldnjsdn@gmail.com.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  const _PolicyItem({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(color: Color(0xFF475569), height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return _SectionBand(
      backgroundColor: const Color(0xFF0F172A),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'AQoong.dev / aqoong.pe.kr',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Flutter, Android, Dart tools',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConstrainedSection extends StatelessWidget {
  const _ConstrainedSection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String id;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(id),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 58),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF475569),
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 26),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionBand extends StatelessWidget {
  const _SectionBand({required this.child, this.backgroundColor, super.key});

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: Center(child: child),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1D4ED8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.color});

  final String type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          type,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Enter valid JSON to generate a typed block visualization.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF64748B)),
      ),
    );
  }
}

String _jsonTypeOf(Object? value) {
  if (value is Map) {
    return 'Object';
  }
  if (value is List) {
    return 'Array';
  }
  if (value is String) {
    return 'String';
  }
  if (value is num) {
    return 'Number';
  }
  if (value is bool) {
    return 'Boolean';
  }
  if (value == null) {
    return 'Null';
  }
  return 'Unknown';
}

Color _typeColor(String type) {
  return switch (type) {
    'Object' => const Color(0xFF2563EB),
    'Array' => const Color(0xFF7C3AED),
    'String' => const Color(0xFF059669),
    'Number' => const Color(0xFFEA580C),
    'Boolean' => const Color(0xFFDB2777),
    'Null' => const Color(0xFF64748B),
    _ => const Color(0xFF334155),
  };
}

String _sizeLabel(Object? value) {
  if (value is Map) {
    return '${value.length} keys';
  }
  if (value is List) {
    return '${value.length} items';
  }
  return '';
}

String _formatScalar(Object? value) {
  if (value is String) {
    return '"$value"';
  }
  if (value == null) {
    return 'null';
  }
  return value.toString();
}

const _sampleJson = '''
{
  "site": "AQoong.dev",
  "purpose": ["Flutter packages", "Android libraries", "JSON parser"],
  "adsenseReady": true,
  "packageCount": 11,
  "examples": {
    "api": "response analysis",
    "firebase": null
  }
}
''';
