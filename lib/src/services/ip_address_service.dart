// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import '../utils/ip_address_tools.dart';

class IpAddressInfo {
  const IpAddressInfo(this.address, this.version);

  final String address;
  final IpVersion version;
}

enum LocalIpDiscoveryState { available, privacyProtected, unavailable }

class LocalIpDiscovery {
  const LocalIpDiscovery({required this.addresses, required this.state});

  final List<IpAddressInfo> addresses;
  final LocalIpDiscoveryState state;
}

class IpAddressSnapshot {
  const IpAddressSnapshot({
    required this.publicAddresses,
    required this.localDiscovery,
  });

  final List<IpAddressInfo> publicAddresses;
  final LocalIpDiscovery localDiscovery;
}

class IpAddressService {
  const IpAddressService();

  Future<IpAddressSnapshot> lookup() async {
    final publicFuture = _lookupPublicAddresses();
    final localFuture = _lookupLocalAddresses();

    return IpAddressSnapshot(
      publicAddresses: await publicFuture,
      localDiscovery: await localFuture,
    );
  }

  Future<List<IpAddressInfo>> _lookupPublicAddresses() async {
    final responses = await Future.wait([
      _requestPublicAddress('https://api.ipify.org?format=json'),
      _requestPublicAddress('https://api64.ipify.org?format=json'),
    ]);
    final addresses = <String, IpAddressInfo>{};
    for (final address in responses.whereType<String>()) {
      final version = ipVersionOf(address);
      if (version != null) {
        addresses[address] = IpAddressInfo(address, version);
      }
    }
    final result = addresses.values.toList(growable: false);
    result.sort((a, b) => a.version.index.compareTo(b.version.index));
    return result;
  }

  Future<String?> _requestPublicAddress(String url) async {
    try {
      final response = await html.HttpRequest.getString(
        url,
      ).timeout(const Duration(seconds: 5));
      final decoded = jsonDecode(response);
      if (decoded is Map<String, dynamic>) {
        final address = decoded['ip'];
        if (address is String && ipVersionOf(address.trim()) != null) {
          return address.trim();
        }
      }
    } catch (_) {
      // A missing IP family or a blocked third-party request is non-fatal.
    }
    return null;
  }

  Future<LocalIpDiscovery> _lookupLocalAddresses() async {
    if (!html.RtcPeerConnection.supported) {
      return const LocalIpDiscovery(
        addresses: [],
        state: LocalIpDiscoveryState.unavailable,
      );
    }

    html.RtcPeerConnection? connection;
    StreamSubscription<html.RtcPeerConnectionIceEvent>? subscription;
    final gatheringComplete = Completer<void>();
    final addresses = <String>{};
    var privacyProtected = false;

    try {
      connection = html.RtcPeerConnection({'iceServers': <Object>[]});
      subscription = connection.onIceCandidate.listen((event) {
        final candidate = event.candidate?.candidate;
        if (candidate == null || candidate.isEmpty) {
          if (!gatheringComplete.isCompleted) {
            gatheringComplete.complete();
          }
          return;
        }

        final address = hostAddressFromIceCandidate(candidate);
        if (address == null) {
          return;
        }
        if (isMdnsHost(address)) {
          privacyProtected = true;
        } else if (isPrivateIpAddress(address)) {
          addresses.add(address);
        }
      });

      connection.createDataChannel('local-ip-discovery');
      final offer = await connection.createOffer();
      await connection.setLocalDescription({
        'type': offer.type ?? 'offer',
        'sdp': offer.sdp ?? '',
      });
      await gatheringComplete.future.timeout(
        const Duration(seconds: 4),
        onTimeout: () {},
      );
    } catch (_) {
      return const LocalIpDiscovery(
        addresses: [],
        state: LocalIpDiscoveryState.unavailable,
      );
    } finally {
      await subscription?.cancel();
      connection?.close();
    }

    final result =
        addresses
            .map((address) => IpAddressInfo(address, ipVersionOf(address)!))
            .toList(growable: false)
          ..sort((a, b) {
            final version = a.version.index.compareTo(b.version.index);
            return version != 0 ? version : a.address.compareTo(b.address);
          });
    return LocalIpDiscovery(
      addresses: result,
      state: result.isNotEmpty
          ? LocalIpDiscoveryState.available
          : privacyProtected
          ? LocalIpDiscoveryState.privacyProtected
          : LocalIpDiscoveryState.unavailable,
    );
  }
}
