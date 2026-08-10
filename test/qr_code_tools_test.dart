import 'package:aqoong_homepage/src/utils/qr_code_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QR payloads', () {
    test('normalizes and validates URLs', () {
      expect(
        createQrPayload(QrContentType.url, {'url': 'aqoong.pe.kr'}).data,
        'https://aqoong.pe.kr',
      );
      expect(
        createQrPayload(QrContentType.url, {'url': 'not a url'}).isValid,
        isFalse,
      );
    });

    test('creates text, phone, and SMS payloads', () {
      expect(
        createQrPayload(QrContentType.text, {'text': 'Hello QR'}).data,
        'Hello QR',
      );
      expect(
        createQrPayload(QrContentType.phone, {'phone': '+821012345678'}).data,
        'tel:+821012345678',
      );
      expect(
        createQrPayload(QrContentType.sms, {
          'phone': '+821012345678',
          'message': '안녕하세요',
        }).data,
        'SMSTO:+821012345678:안녕하세요',
      );
    });

    test('creates a mailto payload', () {
      final result = createQrPayload(QrContentType.email, {
        'email': 'hello@example.com',
        'subject': 'QR test',
        'body': 'Hello',
      });

      expect(result.isValid, isTrue);
      expect(result.data, startsWith('mailto:hello@example.com?'));
      expect(result.data, contains('subject=QR+test'));
      expect(result.data, contains('body=Hello'));
    });

    test('creates escaped vCard and MeCard payloads', () {
      final vcard = createQrPayload(QrContentType.vcard, {
        'firstName': '길동',
        'lastName': '홍',
        'organization': 'A, B',
        'phone': '+821012345678',
      });
      final mecard = createQrPayload(QrContentType.mecard, {
        'firstName': '길동',
        'lastName': '홍',
        'address': '서울; 대한민국',
      });

      expect(vcard.data, contains('BEGIN:VCARD\r\nVERSION:3.0'));
      expect(vcard.data, contains('N:홍;길동;;;'));
      expect(vcard.data, contains(r'ORG:A\, B'));
      expect(vcard.data, endsWith('END:VCARD'));
      expect(mecard.data, startsWith('MECARD:N:홍,길동;'));
      expect(mecard.data, contains(r'ADR:서울\; 대한민국'));
      expect(mecard.data, endsWith(';;'));
    });

    test('validates and creates location payloads', () {
      final result = createQrPayload(QrContentType.location, {
        'latitude': '37.5665',
        'longitude': '126.9780',
        'label': '서울시청',
      });

      expect(result.data, startsWith('geo:37.5665,126.9780?q='));
      expect(
        createQrPayload(QrContentType.location, {
          'latitude': '91',
          'longitude': '126',
        }).isValid,
        isFalse,
      );
    });

    test('creates escaped Wi-Fi payloads and requires secured password', () {
      final result = createQrPayload(QrContentType.wifi, {
        'ssid': 'Cafe;Guest',
        'security': 'WPA',
        'password': 'pass:word',
        'hidden': 'true',
      });

      expect(result.data, r'WIFI:T:WPA;S:Cafe\;Guest;P:pass\:word;H:true;;');
      expect(
        createQrPayload(QrContentType.wifi, {
          'ssid': 'Cafe',
          'security': 'WPA',
        }).isValid,
        isFalse,
      );
      expect(
        createQrPayload(QrContentType.wifi, {
          'ssid': 'Cafe',
          'security': 'nopass',
        }).isValid,
        isTrue,
      );
    });
  });
}
