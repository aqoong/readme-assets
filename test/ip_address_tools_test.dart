import 'package:aqoong_homepage/src/utils/ip_address_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ipVersionOf', () {
    test('recognizes IPv4 and IPv6 addresses', () {
      expect(ipVersionOf('192.168.0.10'), IpVersion.ipv4);
      expect(ipVersionOf('2001:db8::1'), IpVersion.ipv6);
      expect(ipVersionOf('not-an-ip'), isNull);
      expect(ipVersionOf('999.1.1.1'), isNull);
      expect(ipVersionOf('2001:::1'), isNull);
    });
  });

  group('isPrivateIpAddress', () {
    test('recognizes private and shared IPv4 ranges', () {
      expect(isPrivateIpAddress('10.0.0.1'), isTrue);
      expect(isPrivateIpAddress('172.31.2.3'), isTrue);
      expect(isPrivateIpAddress('192.168.1.20'), isTrue);
      expect(isPrivateIpAddress('100.64.0.1'), isTrue);
      expect(isPrivateIpAddress('8.8.8.8'), isFalse);
    });

    test('recognizes local IPv6 ranges', () {
      expect(isPrivateIpAddress('fd00::1'), isTrue);
      expect(isPrivateIpAddress('fe80::10'), isTrue);
      expect(isPrivateIpAddress('2001:4860:4860::8888'), isFalse);
    });
  });

  group('hostAddressFromIceCandidate', () {
    test('returns an address from host candidates', () {
      expect(
        hostAddressFromIceCandidate(
          'candidate:1 1 UDP 2122252543 192.168.1.12 53542 typ host generation 0',
        ),
        '192.168.1.12',
      );
      expect(
        hostAddressFromIceCandidate(
          'candidate:2 1 udp 1 random-id.local 50100 typ host',
        ),
        'random-id.local',
      );
    });

    test('ignores server-reflexive candidates', () {
      expect(
        hostAddressFromIceCandidate(
          'candidate:3 1 udp 1 203.0.113.20 50100 typ srflx raddr 0.0.0.0',
        ),
        isNull,
      );
    });
  });
}
