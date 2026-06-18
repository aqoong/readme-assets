import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../viewmodels/json_parser_view_model.dart';
import '../../widgets/common_widgets.dart';

class JsonParserSection extends StatefulWidget {
  const JsonParserSection({super.key});

  @override
  State<JsonParserSection> createState() => _JsonParserSectionState();
}

class _JsonParserSectionState extends State<JsonParserSection> {
  late final JsonParserViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = JsonParserViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return SectionBand(
          backgroundColor: const Color(0xFFEEF4FF),
          child: ConstrainedSection(
            id: 'json-parser',
            title: 'JSON Online Parser',
            subtitle:
                'Paste API responses, Firebase documents, config files, or docs examples and inspect them as typed nested blocks.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;
                    final editor = _JsonInputCard(
                      controller: _viewModel.controller,
                      error: _viewModel.error,
                      parsed: _viewModel.parsed,
                      onPrettyPrint: _viewModel.prettyPrint,
                      onMinify: _viewModel.minify,
                      onClear: _viewModel.clear,
                      onLoadSample: _viewModel.loadSample,
                      onDownloadJson: _viewModel.downloadJson,
                    );
                    final preview = _JsonPreviewCard(
                      captureKey: _viewModel.captureKey,
                      parsed: _viewModel.parsed,
                      error: _viewModel.error,
                      isDownloading: _viewModel.isDownloading,
                      onDownload: _viewModel.downloadPng,
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
                const SizedBox(height: 26),
                const _JsonParserGuide(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _JsonInputCard extends StatelessWidget {
  const _JsonInputCard({
    required this.controller,
    required this.error,
    required this.parsed,
    required this.onPrettyPrint,
    required this.onMinify,
    required this.onClear,
    required this.onLoadSample,
    required this.onDownloadJson,
  });

  final TextEditingController controller;
  final String? error;
  final Object? parsed;
  final VoidCallback onPrettyPrint;
  final VoidCallback onMinify;
  final VoidCallback onClear;
  final VoidCallback onLoadSample;
  final VoidCallback onDownloadJson;

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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: onPrettyPrint,
                  icon: const Icon(Icons.format_align_left),
                  label: const Text('Pretty print'),
                ),
                OutlinedButton.icon(
                  onPressed: onMinify,
                  icon: const Icon(Icons.compress),
                  label: const Text('Minify'),
                ),
                OutlinedButton.icon(
                  onPressed: onLoadSample,
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Sample'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _copy(context, controller.text),
                  icon: const Icon(Icons.copy_all),
                  label: const Text('Copy'),
                ),
                OutlinedButton.icon(
                  onPressed: parsed == null || error != null
                      ? null
                      : onDownloadJson,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Download'),
                ),
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: error == null
                  ? const StatusLine(
                      key: ValueKey('valid'),
                      icon: Icons.check_circle,
                      color: Color(0xFF15803D),
                      label: 'Valid JSON',
                    )
                  : StatusLine(
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

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('JSON copied')));
    }
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

class _JsonValueBlock extends StatefulWidget {
  const _JsonValueBlock({
    required this.label,
    required this.value,
    required this.depth,
  });

  final String label;
  final Object? value;
  final int depth;

  @override
  State<_JsonValueBlock> createState() => _JsonValueBlockState();
}

class _JsonValueBlockState extends State<_JsonValueBlock> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final currentValue = widget.value;
    final type = _jsonTypeOf(widget.value);
    final color = _typeColor(type);
    final isComplex = currentValue is Map || currentValue is List;

    return Container(
      margin: EdgeInsets.only(left: widget.depth == 0 ? 0 : 14, top: 10),
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
                widget.label,
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
              if (isComplex)
                IconButton(
                  tooltip: _expanded ? 'Collapse node' : 'Expand node',
                  onPressed: () => setState(() => _expanded = !_expanded),
                  icon: Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (!_expanded && isComplex)
            Text(
              _compactComplexLabel(currentValue),
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Color(0xFF64748B),
              ),
            )
          else if (currentValue is Map<String, dynamic>)
            for (final entry in currentValue.entries)
              _JsonValueBlock(
                label: entry.key,
                value: entry.value,
                depth: widget.depth + 1,
              )
          else if (currentValue is List)
            for (var index = 0; index < currentValue.length; index++)
              _JsonValueBlock(
                label: '[$index]',
                value: currentValue[index],
                depth: widget.depth + 1,
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

class _JsonParserGuide extends StatelessWidget {
  const _JsonParserGuide();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JSON Parser guide',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            const Text(
              'Paste JSON into the editor to validate it locally in your browser. Pretty print expands the structure with indentation for reading, while minify removes whitespace for compact transport or config storage. The typed block view distinguishes object, array, string, number, boolean, and null values, and nested nodes can be collapsed when the payload is deep.',
              style: TextStyle(color: Color(0xFF475569), height: 1.6),
            ),
            const SizedBox(height: 14),
            const Text(
              'Common syntax errors include missing commas between object fields, trailing commas after the final item, unquoted object keys, and strings that use single quotes. This tool does not send your JSON to a server; still avoid pasting secrets, production tokens, or private customer data into any browser tool.',
              style: TextStyle(color: Color(0xFF475569), height: 1.6),
            ),
          ],
        ),
      ),
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

String _compactComplexLabel(Object? value) {
  if (value is Map) {
    return '{ ... ${value.length} keys }';
  }
  if (value is List) {
    return '[ ... ${value.length} items ]';
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
