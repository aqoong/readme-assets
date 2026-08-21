enum IpVersion {
  ipv4('IPv4'),
  ipv6('IPv6');

  const IpVersion(this.label);

  final String label;
}

IpVersion? ipVersionOf(String value) {
  if (_isIpv4(value)) {
    return IpVersion.ipv4;
  }
  if (_isIpv6(value)) {
    return IpVersion.ipv6;
  }
  return null;
}

bool isPrivateIpAddress(String value) {
  final version = ipVersionOf(value);
  if (version == IpVersion.ipv4) {
    final octets = value.split('.').map(int.parse).toList(growable: false);
    return octets[0] == 10 ||
        (octets[0] == 172 && octets[1] >= 16 && octets[1] <= 31) ||
        (octets[0] == 192 && octets[1] == 168) ||
        (octets[0] == 169 && octets[1] == 254) ||
        (octets[0] == 100 && octets[1] >= 64 && octets[1] <= 127) ||
        octets.every((octet) => octet == 0) ||
        octets[0] == 127;
  }
  if (version == IpVersion.ipv6) {
    final normalized = value.toLowerCase();
    return normalized == '::' ||
        normalized == '::1' ||
        normalized.startsWith('fc') ||
        normalized.startsWith('fd') ||
        RegExp(r'^fe[89ab]').hasMatch(normalized);
  }
  return false;
}

bool isMdnsHost(String value) => value.toLowerCase().endsWith('.local');

String? hostAddressFromIceCandidate(String candidate) {
  final parts = candidate.trim().split(RegExp(r'\s+'));
  if (parts.length < 8) {
    return null;
  }

  final typeIndex = parts.indexOf('typ');
  if (typeIndex < 0 || typeIndex + 1 >= parts.length) {
    return null;
  }
  if (parts[typeIndex + 1].toLowerCase() != 'host') {
    return null;
  }

  final address = parts[4].replaceAll(RegExp(r'^\[|\]$'), '');
  if (ipVersionOf(address) != null || isMdnsHost(address)) {
    return address;
  }
  return null;
}

bool _isIpv4(String value) {
  final parts = value.split('.');
  if (parts.length != 4) {
    return false;
  }
  for (final part in parts) {
    if (part.isEmpty || !RegExp(r'^\d{1,3}$').hasMatch(part)) {
      return false;
    }
    final number = int.parse(part);
    if (number > 255) {
      return false;
    }
  }
  return true;
}

bool _isIpv6(String value) {
  if (!value.contains(':') ||
      value.contains(':::') ||
      value.length > 45 ||
      !RegExp(r'^[0-9a-fA-F:.]+$').hasMatch(value)) {
    return false;
  }

  final doubleColonCount = RegExp(r'::').allMatches(value).length;
  if (doubleColonCount > 1) {
    return false;
  }
  final groups = value.split(':');
  if (!value.contains('::') && groups.length != 8) {
    return false;
  }
  if (value.contains('::') && groups.length > 8) {
    return false;
  }
  return groups.every((group) {
    if (group.isEmpty) {
      return true;
    }
    if (group.contains('.')) {
      return _isIpv4(group);
    }
    return group.length <= 4 && RegExp(r'^[0-9a-fA-F]+$').hasMatch(group);
  });
}
