enum QrContentType {
  url,
  text,
  email,
  phone,
  sms,
  vcard,
  mecard,
  location,
  wifi,
}

extension QrContentTypeLabel on QrContentType {
  String get label => switch (this) {
    QrContentType.url => 'URL',
    QrContentType.text => 'Text',
    QrContentType.email => 'Email',
    QrContentType.phone => 'Phone',
    QrContentType.sms => 'SMS',
    QrContentType.vcard => 'vCard',
    QrContentType.mecard => 'MeCard',
    QrContentType.location => 'Location',
    QrContentType.wifi => 'Wi-Fi',
  };
}

class QrPayloadResult {
  const QrPayloadResult.valid(this.data) : error = null;
  const QrPayloadResult.invalid(this.error) : data = null;

  final String? data;
  final String? error;

  bool get isValid => data != null && error == null;
}

QrPayloadResult createQrPayload(
  QrContentType type,
  Map<String, String> values,
) {
  String value(String key) => values[key]?.trim() ?? '';

  switch (type) {
    case QrContentType.url:
      final rawUrl = value('url');
      if (rawUrl.isEmpty) {
        return const QrPayloadResult.invalid('URL을 입력해 주세요.');
      }
      final normalized = rawUrl.contains('://') ? rawUrl : 'https://$rawUrl';
      final uri = Uri.tryParse(normalized);
      if (uri == null ||
          RegExp(r'\s').hasMatch(rawUrl) ||
          !const {'http', 'https'}.contains(uri.scheme) ||
          uri.host.isEmpty) {
        return const QrPayloadResult.invalid(
          'http:// 또는 https:// 형식의 올바른 URL을 입력해 주세요.',
        );
      }
      return QrPayloadResult.valid(uri.toString());

    case QrContentType.text:
      final text = value('text');
      return text.isEmpty
          ? const QrPayloadResult.invalid('텍스트를 입력해 주세요.')
          : QrPayloadResult.valid(text);

    case QrContentType.email:
      final email = value('email');
      if (!_isEmail(email)) {
        return const QrPayloadResult.invalid('올바른 이메일 주소를 입력해 주세요.');
      }
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (value('subject').isNotEmpty) 'subject': value('subject'),
          if (value('body').isNotEmpty) 'body': value('body'),
        },
      );
      return QrPayloadResult.valid(uri.toString());

    case QrContentType.phone:
      final phone = value('phone');
      return phone.isEmpty
          ? const QrPayloadResult.invalid('전화번호를 입력해 주세요.')
          : QrPayloadResult.valid('tel:$phone');

    case QrContentType.sms:
      final phone = value('phone');
      if (phone.isEmpty) {
        return const QrPayloadResult.invalid('수신 전화번호를 입력해 주세요.');
      }
      return QrPayloadResult.valid('SMSTO:$phone:${value('message')}');

    case QrContentType.vcard:
      final firstName = value('firstName');
      final lastName = value('lastName');
      if (firstName.isEmpty && lastName.isEmpty) {
        return const QrPayloadResult.invalid('이름 또는 성을 입력해 주세요.');
      }
      final fullName = [
        firstName,
        lastName,
      ].where((part) => part.isNotEmpty).join(' ');
      final lines = <String>[
        'BEGIN:VCARD',
        'VERSION:3.0',
        'N:${_escapeVCard(lastName)};${_escapeVCard(firstName)};;;',
        'FN:${_escapeVCard(fullName)}',
        if (value('organization').isNotEmpty)
          'ORG:${_escapeVCard(value('organization'))}',
        if (value('title').isNotEmpty) 'TITLE:${_escapeVCard(value('title'))}',
        if (value('phone').isNotEmpty)
          'TEL;TYPE=CELL:${_escapeVCard(value('phone'))}',
        if (value('email').isNotEmpty) 'EMAIL:${_escapeVCard(value('email'))}',
        if (value('website').isNotEmpty)
          'URL:${_escapeVCard(value('website'))}',
        if (_hasAddress(values))
          'ADR;TYPE=WORK:;;${_escapeVCard(value('street'))};'
              '${_escapeVCard(value('city'))};${_escapeVCard(value('region'))};'
              '${_escapeVCard(value('postalCode'))};'
              '${_escapeVCard(value('country'))}',
        if (value('note').isNotEmpty) 'NOTE:${_escapeVCard(value('note'))}',
        'END:VCARD',
      ];
      return QrPayloadResult.valid(lines.join('\r\n'));

    case QrContentType.mecard:
      final firstName = value('firstName');
      final lastName = value('lastName');
      if (firstName.isEmpty && lastName.isEmpty) {
        return const QrPayloadResult.invalid('이름 또는 성을 입력해 주세요.');
      }
      final fields = <String>[
        'N:${_escapeMeCard(lastName)},${_escapeMeCard(firstName)}',
        if (value('organization').isNotEmpty)
          'ORG:${_escapeMeCard(value('organization'))}',
        if (value('phone').isNotEmpty) 'TEL:${_escapeMeCard(value('phone'))}',
        if (value('email').isNotEmpty) 'EMAIL:${_escapeMeCard(value('email'))}',
        if (value('website').isNotEmpty)
          'URL:${_escapeMeCard(value('website'))}',
        if (value('address').isNotEmpty)
          'ADR:${_escapeMeCard(value('address'))}',
        if (value('note').isNotEmpty) 'NOTE:${_escapeMeCard(value('note'))}',
      ];
      return QrPayloadResult.valid('MECARD:${fields.join(';')};;');

    case QrContentType.location:
      final latitude = double.tryParse(value('latitude'));
      final longitude = double.tryParse(value('longitude'));
      if (latitude == null || latitude < -90 || latitude > 90) {
        return const QrPayloadResult.invalid('위도는 -90부터 90 사이의 숫자로 입력해 주세요.');
      }
      if (longitude == null || longitude < -180 || longitude > 180) {
        return const QrPayloadResult.invalid('경도는 -180부터 180 사이의 숫자로 입력해 주세요.');
      }
      final coordinates = '${value('latitude')},${value('longitude')}';
      final label = value('label');
      if (label.isEmpty) {
        return QrPayloadResult.valid('geo:$coordinates');
      }
      final query = Uri.encodeComponent('$coordinates ($label)');
      return QrPayloadResult.valid('geo:$coordinates?q=$query');

    case QrContentType.wifi:
      final ssid = value('ssid');
      final security = value('security').isEmpty ? 'WPA' : value('security');
      final password = values['password'] ?? '';
      if (ssid.isEmpty) {
        return const QrPayloadResult.invalid('Wi-Fi 이름(SSID)을 입력해 주세요.');
      }
      if (security != 'nopass' && password.isEmpty) {
        return const QrPayloadResult.invalid('Wi-Fi 비밀번호를 입력해 주세요.');
      }
      final hidden = value('hidden') == 'true';
      return QrPayloadResult.valid(
        'WIFI:T:$security;S:${_escapeWifi(ssid)};'
        'P:${_escapeWifi(password)};H:$hidden;;',
      );
  }
}

bool _isEmail(String value) {
  return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
}

bool _hasAddress(Map<String, String> values) {
  const keys = ['street', 'city', 'region', 'postalCode', 'country'];
  return keys.any((key) => values[key]?.trim().isNotEmpty ?? false);
}

String _escapeVCard(String value) {
  return value
      .replaceAll('\\', r'\\')
      .replaceAll(';', r'\;')
      .replaceAll(',', r'\,')
      .replaceAll('\r\n', r'\n')
      .replaceAll('\n', r'\n');
}

String _escapeMeCard(String value) {
  return value
      .replaceAll('\\', r'\\')
      .replaceAll(';', r'\;')
      .replaceAll(',', r'\,')
      .replaceAll(':', r'\:')
      .replaceAll('\r\n', r'\n')
      .replaceAll('\n', r'\n');
}

String _escapeWifi(String value) {
  return value.replaceAllMapped(
    RegExp(r'[\\;,:\"]'),
    (match) => '\\${match.group(0)}',
  );
}
