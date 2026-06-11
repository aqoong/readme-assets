// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

import '../../../package_catalog.dart';
import '../../widgets/common_widgets.dart';

class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final flutterPackages = packagesByCategory('Flutter');
    final androidPackages = packagesByCategory('Android');

    return SectionBand(
      key: const ValueKey('packages'),
      child: ConstrainedSection(
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
                  title: SizedBox(
                    height: 24,
                    child: SizeTailoredTextWidget(
                      detail.packageName,
                      maxLines: 1,
                      minFontSize: 13,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
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
              children: [for (final item in section.items) Tag(label: item)],
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
      child: SizedBox(
        height: isHeader ? 18 : 34,
        child: SizeTailoredTextWidget(
          text,
          maxLines: isHeader ? 1 : 2,
          minFontSize: 8,
          style: TextStyle(
            fontFamily: isHeader ? null : 'monospace',
            fontSize: 12,
            color: const Color(0xFF334155),
            fontWeight: isHeader ? FontWeight.w800 : FontWeight.w500,
          ),
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
            SizedBox(
              height: 30,
              child: SizeTailoredTextWidget(
                info.name,
                maxLines: 1,
                minFontSize: 14,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 22,
              child: SizeTailoredTextWidget(
                info.tagline,
                maxLines: 1,
                minFontSize: 11,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Tag(label: info.category),
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
              children: [for (final item in info.highlights) Tag(label: item)],
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
