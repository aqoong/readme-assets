// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/qr_code_tools.dart';
import '../../widgets/adsense_banner.dart';
import '../../widgets/common_widgets.dart';

class QrCodeGeneratorSection extends StatefulWidget {
  const QrCodeGeneratorSection({super.key});

  @override
  State<QrCodeGeneratorSection> createState() => _QrCodeGeneratorSectionState();
}

class _QrCodeGeneratorSectionState extends State<QrCodeGeneratorSection> {
  final Map<String, TextEditingController> _controllers = {};
  final GlobalKey _captureKey = GlobalKey();

  QrContentType _type = QrContentType.url;
  String _wifiSecurity = 'WPA';
  bool _wifiHidden = false;
  bool _obscureWifiPassword = true;
  String? _generatedData;
  QrCode? _generatedQr;
  QrContentType? _generatedType;
  String? _error;
  bool _isDownloading = false;

  TextEditingController _controller(String key) {
    return _controllers.putIfAbsent(key, TextEditingController.new);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      backgroundColor: const Color(0xFFEEF4FF),
      child: ConstrainedSection(
        id: 'qr-code-generator',
        title: '온라인 QR 코드 생성기',
        subtitle:
            'URL, 텍스트, 연락처, 위치, Wi-Fi 정보를 QR 코드 이미지로 만드세요. 입력한 내용은 서버로 전송되지 않고 브라우저 안에서만 처리됩니다.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypeSelector(context),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final input = _buildInputCard(context);
                final preview = _buildPreviewCard(context);
                if (constraints.maxWidth >= 920) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: input),
                      const SizedBox(width: 18),
                      Expanded(flex: 5, child: preview),
                    ],
                  );
                }
                return Column(
                  children: [input, const SizedBox(height: 18), preview],
                );
              },
            ),
            const SizedBox(height: 26),
            const AdSenseBanner(placement: 'qr-code-generator'),
            const SizedBox(height: 26),
            const _QrCodeGuide(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QR 코드 유형',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in QrContentType.values)
                  ChoiceChip(
                    avatar: Icon(_iconFor(type), size: 18),
                    label: Text(type.label),
                    selected: _type == type,
                    onSelected: (_) => _selectType(type),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconFor(_type)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${_type.label} 정보 입력',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: KeyedSubtree(
                key: ValueKey(_type),
                child: _buildFields(context),
              ),
            ),
            const SizedBox(height: 18),
            if (_error != null) ...[
              StatusLine(
                icon: Icons.error_outline,
                color: const Color(0xFFB91C1C),
                label: _error!,
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _generate,
                icon: const Icon(Icons.qr_code_2),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('생성'),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _clearCurrentType,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('입력 초기화'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFields(BuildContext context) {
    if (_type == QrContentType.wifi) {
      return _buildWifiFields();
    }

    final fields = _fieldsFor(_type);
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 620;
        final halfWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 14,
          children: [
            for (final field in fields)
              SizedBox(
                width: twoColumns && !field.fullWidth
                    ? halfWidth
                    : constraints.maxWidth,
                child: TextField(
                  key: ValueKey('${_type.name}-${field.key}'),
                  controller: _controller('${_type.name}.${field.key}'),
                  minLines: field.lines,
                  maxLines: field.lines,
                  keyboardType: field.keyboardType,
                  textInputAction: field.lines > 1
                      ? TextInputAction.newline
                      : TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: field.label,
                    hintText: field.hint,
                    helperText: field.helper,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildWifiFields() {
    final passwordKey = '${_type.name}.password';
    return Column(
      children: [
        TextField(
          controller: _controller('${_type.name}.ssid'),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Wi-Fi 이름 (SSID) *',
            hintText: '예: AQoong Wi-Fi',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _wifiSecurity,
          decoration: const InputDecoration(
            labelText: '보안 방식',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'WPA', child: Text('WPA / WPA2 / WPA3')),
            DropdownMenuItem(value: 'WEP', child: Text('WEP')),
            DropdownMenuItem(value: 'nopass', child: Text('암호 없음')),
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _wifiSecurity = value;
              _error = null;
            });
          },
        ),
        if (_wifiSecurity != 'nopass') ...[
          const SizedBox(height: 14),
          TextField(
            controller: _controller(passwordKey),
            obscureText: _obscureWifiPassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _generate(),
            decoration: InputDecoration(
              labelText: '비밀번호 *',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: _obscureWifiPassword ? '비밀번호 보기' : '비밀번호 숨기기',
                onPressed: () => setState(
                  () => _obscureWifiPassword = !_obscureWifiPassword,
                ),
                icon: Icon(
                  _obscureWifiPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 6),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('숨겨진 네트워크'),
          subtitle: const Text('SSID를 브로드캐스트하지 않는 Wi-Fi인 경우 켜세요.'),
          value: _wifiHidden,
          onChanged: (value) => setState(() => _wifiHidden = value),
        ),
      ],
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    final data = _generatedData;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.image_outlined),
                const SizedBox(width: 10),
                Text(
                  'QR 코드 이미지',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: data == null || _generatedQr == null
                    ? Container(
                        key: const ValueKey('empty-preview'),
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2,
                              size: 72,
                              color: Color(0xFF94A3B8),
                            ),
                            SizedBox(height: 14),
                            Text(
                              '정보를 입력하고 생성 버튼을 눌러 주세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )
                    : RepaintBoundary(
                        key: _captureKey,
                        child: ColoredBox(
                          key: ValueKey(data),
                          color: Colors.white,
                          child: QrImageView.withQr(
                            qr: _generatedQr!,
                            size: 280,
                            padding: const EdgeInsets.all(18),
                            backgroundColor: Colors.white,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xFF0F172A),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Color(0xFF0F172A),
                            ),
                            semanticsLabel:
                                '${_generatedType?.label ?? ''} QR 코드',
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 18),
            if (data != null) ...[
              const StatusLine(
                icon: Icons.check_circle,
                color: Color(0xFF15803D),
                label: 'QR 코드가 생성되었습니다.',
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  data,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _isDownloading ? null : _downloadPng,
                    icon: _isDownloading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_outlined),
                    label: Text(_isDownloading ? '저장 중...' : 'PNG 다운로드'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _copyData(context, data),
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text('내용 복사'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _selectType(QrContentType type) {
    if (_type == type) {
      return;
    }
    setState(() {
      _type = type;
      _error = null;
      _generatedData = null;
      _generatedQr = null;
      _generatedType = null;
    });
  }

  void _generate() {
    FocusManager.instance.primaryFocus?.unfocus();
    final prefix = '${_type.name}.';
    final values = <String, String>{
      for (final entry in _controllers.entries)
        if (entry.key.startsWith(prefix))
          entry.key.substring(prefix.length): entry.value.text,
      if (_type == QrContentType.wifi) 'security': _wifiSecurity,
      if (_type == QrContentType.wifi) 'hidden': '$_wifiHidden',
    };
    final result = createQrPayload(_type, values);
    if (!result.isValid) {
      setState(() => _error = result.error);
      return;
    }

    final validation = QrValidator.validate(
      data: result.data!,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
    );
    if (!validation.isValid || validation.qrCode == null) {
      setState(() {
        _error = validation.status == QrValidationStatus.contentTooLong
            ? '입력 내용이 QR 코드에 담기에는 너무 깁니다. 내용을 줄여 주세요.'
            : 'QR 코드를 생성하지 못했습니다. 입력 내용을 확인해 주세요.';
      });
      return;
    }

    setState(() {
      _generatedData = result.data;
      _generatedQr = validation.qrCode;
      _generatedType = _type;
      _error = null;
    });
  }

  void _clearCurrentType() {
    final prefix = '${_type.name}.';
    for (final entry in _controllers.entries) {
      if (entry.key.startsWith(prefix)) {
        entry.value.clear();
      }
    }
    setState(() {
      if (_type == QrContentType.wifi) {
        _wifiSecurity = 'WPA';
        _wifiHidden = false;
        _obscureWifiPassword = true;
      }
      _error = null;
      if (_generatedType == _type) {
        _generatedData = null;
        _generatedQr = null;
        _generatedType = null;
      }
    });
  }

  Future<void> _downloadPng() async {
    if (_generatedData == null || _isDownloading) {
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
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return;
      }
      final bytes = byteData.buffer.asUint8List();
      final blob = html.Blob([bytes], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = 'aqoong-${_generatedType?.name ?? 'qr'}-qr-code.png'
        ..style.display = 'none';
      html.document.body?.children.add(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  Future<void> _copyData(BuildContext context, String data) async {
    await Clipboard.setData(ClipboardData(text: data));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('QR 코드 내용을 복사했습니다.')));
  }
}

class _FieldSpec {
  const _FieldSpec(
    this.key,
    this.label,
    this.hint, {
    this.helper,
    this.lines = 1,
    this.fullWidth = false,
    this.keyboardType = TextInputType.text,
  });

  final String key;
  final String label;
  final String hint;
  final String? helper;
  final int lines;
  final bool fullWidth;
  final TextInputType keyboardType;
}

List<_FieldSpec> _fieldsFor(QrContentType type) {
  return switch (type) {
    QrContentType.url => const [
      _FieldSpec(
        'url',
        'URL *',
        'https://aqoong.pe.kr',
        helper: '프로토콜을 생략하면 https://가 자동으로 추가됩니다.',
        fullWidth: true,
        keyboardType: TextInputType.url,
      ),
    ],
    QrContentType.text => const [
      _FieldSpec(
        'text',
        '텍스트 *',
        'QR 코드에 담을 내용을 입력하세요.',
        lines: 6,
        fullWidth: true,
        keyboardType: TextInputType.multiline,
      ),
    ],
    QrContentType.email => const [
      _FieldSpec(
        'email',
        '받는 사람 이메일 *',
        'hello@example.com',
        fullWidth: true,
        keyboardType: TextInputType.emailAddress,
      ),
      _FieldSpec('subject', '제목', '문의드립니다', fullWidth: true),
      _FieldSpec(
        'body',
        '본문',
        '이메일 본문을 입력하세요.',
        lines: 5,
        fullWidth: true,
        keyboardType: TextInputType.multiline,
      ),
    ],
    QrContentType.phone => const [
      _FieldSpec(
        'phone',
        '전화번호 *',
        '+82 10-1234-5678',
        fullWidth: true,
        keyboardType: TextInputType.phone,
      ),
    ],
    QrContentType.sms => const [
      _FieldSpec(
        'phone',
        '수신 전화번호 *',
        '+82 10-1234-5678',
        fullWidth: true,
        keyboardType: TextInputType.phone,
      ),
      _FieldSpec(
        'message',
        '메시지',
        '미리 입력할 문자 메시지',
        lines: 5,
        fullWidth: true,
        keyboardType: TextInputType.multiline,
      ),
    ],
    QrContentType.vcard => const [
      _FieldSpec('firstName', '이름 (이름/성 중 하나 필수)', '길동'),
      _FieldSpec('lastName', '성', '홍'),
      _FieldSpec('organization', '회사/조직', 'AQoong'),
      _FieldSpec('title', '직함', 'Developer'),
      _FieldSpec(
        'phone',
        '전화번호',
        '+82 10-1234-5678',
        keyboardType: TextInputType.phone,
      ),
      _FieldSpec(
        'email',
        '이메일',
        'hello@example.com',
        keyboardType: TextInputType.emailAddress,
      ),
      _FieldSpec(
        'website',
        '웹사이트',
        'https://example.com',
        fullWidth: true,
        keyboardType: TextInputType.url,
      ),
      _FieldSpec('street', '상세 주소', '테헤란로 123'),
      _FieldSpec('city', '도시', '서울'),
      _FieldSpec('region', '시/도', '서울특별시'),
      _FieldSpec(
        'postalCode',
        '우편번호',
        '06134',
        keyboardType: TextInputType.number,
      ),
      _FieldSpec('country', '국가', '대한민국'),
      _FieldSpec(
        'note',
        '메모',
        '연락처에 함께 저장할 메모',
        lines: 3,
        fullWidth: true,
        keyboardType: TextInputType.multiline,
      ),
    ],
    QrContentType.mecard => const [
      _FieldSpec('firstName', '이름 (이름/성 중 하나 필수)', '길동'),
      _FieldSpec('lastName', '성', '홍'),
      _FieldSpec('organization', '회사/조직', 'AQoong'),
      _FieldSpec(
        'phone',
        '전화번호',
        '+82 10-1234-5678',
        keyboardType: TextInputType.phone,
      ),
      _FieldSpec(
        'email',
        '이메일',
        'hello@example.com',
        keyboardType: TextInputType.emailAddress,
      ),
      _FieldSpec(
        'website',
        '웹사이트',
        'https://example.com',
        fullWidth: true,
        keyboardType: TextInputType.url,
      ),
      _FieldSpec('address', '주소', '대한민국 서울특별시', fullWidth: true),
      _FieldSpec(
        'note',
        '메모',
        '연락처에 함께 저장할 메모',
        lines: 3,
        fullWidth: true,
        keyboardType: TextInputType.multiline,
      ),
    ],
    QrContentType.location => const [
      _FieldSpec(
        'latitude',
        '위도 *',
        '37.5665',
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
      ),
      _FieldSpec(
        'longitude',
        '경도 *',
        '126.9780',
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
      ),
      _FieldSpec(
        'label',
        '장소 이름',
        '서울시청',
        helper: '선택 사항이며 지도 앱에서 위치 이름으로 표시됩니다.',
        fullWidth: true,
      ),
    ],
    QrContentType.wifi => const [],
  };
}

IconData _iconFor(QrContentType type) {
  return switch (type) {
    QrContentType.url => Icons.link,
    QrContentType.text => Icons.text_fields,
    QrContentType.email => Icons.email_outlined,
    QrContentType.phone => Icons.phone_outlined,
    QrContentType.sms => Icons.sms_outlined,
    QrContentType.vcard => Icons.contact_page_outlined,
    QrContentType.mecard => Icons.badge_outlined,
    QrContentType.location => Icons.location_on_outlined,
    QrContentType.wifi => Icons.wifi,
  };
}

class _QrCodeGuide extends StatelessWidget {
  const _QrCodeGuide();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이용 안내',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            const _GuideItem(
              icon: Icons.lock_outline,
              title: '브라우저에서 안전하게 처리',
              body: '입력한 연락처, Wi-Fi 비밀번호 등은 서버에 업로드하거나 저장하지 않습니다.',
            ),
            const _GuideItem(
              icon: Icons.phone_android,
              title: '스캔 전 확인',
              body: '생성한 QR 코드는 실제로 사용할 휴대폰의 기본 카메라 또는 QR 앱으로 한 번 테스트해 주세요.',
            ),
            const _GuideItem(
              icon: Icons.print_outlined,
              title: '선명하게 사용',
              body: 'PNG 파일 주변의 흰 여백을 유지하고, 인쇄할 때 QR 코드를 찌그러뜨리지 마세요.',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  const _GuideItem({
    required this.icon,
    required this.title,
    required this.body,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(color: Color(0xFF475569), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
