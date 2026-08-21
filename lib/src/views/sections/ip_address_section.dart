import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/ip_address_service.dart';
import '../../widgets/adsense_banner.dart';
import '../../widgets/common_widgets.dart';

class IpAddressSection extends StatefulWidget {
  const IpAddressSection({super.key});

  @override
  State<IpAddressSection> createState() => _IpAddressSectionState();
}

class _IpAddressSectionState extends State<IpAddressSection> {
  final IpAddressService _service = const IpAddressService();

  IpAddressSnapshot? _snapshot;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _lookup();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    return SectionBand(
      backgroundColor: const Color(0xFFEEF4FF),
      child: ConstrainedSection(
        id: 'ip-address',
        title: '내 IP 주소 확인',
        subtitle: '현재 인터넷 연결의 공인 IP와 브라우저에서 확인 가능한 공유기 내부 IP를 한눈에 확인하세요.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _lookup,
                icon: _isLoading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? '확인 중...' : '다시 확인'),
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final publicCard = _AddressCard(
                  icon: Icons.public,
                  title: '공인 IP',
                  subtitle: '인터넷에서 현재 연결을 식별하는 주소',
                  isLoading: _isLoading,
                  addresses: snapshot?.publicAddresses ?? const [],
                  emptyMessage: '공인 IP를 확인하지 못했습니다. 네트워크 연결이나 차단 설정을 확인해 주세요.',
                  onCopy: _copyAddress,
                );
                final localDiscovery = snapshot?.localDiscovery;
                final localCard = _AddressCard(
                  icon: Icons.router_outlined,
                  title: '내부 IP',
                  subtitle: '공유기 또는 로컬 네트워크가 기기에 할당한 주소',
                  isLoading: _isLoading,
                  addresses: localDiscovery?.addresses ?? const [],
                  emptyMessage: _localEmptyMessage(localDiscovery?.state),
                  infoMessage:
                      localDiscovery?.state ==
                          LocalIpDiscoveryState.privacyProtected
                      ? '브라우저의 개인정보 보호 기능이 실제 내부 IP를 mDNS 주소로 대체했습니다.'
                      : null,
                  onCopy: _copyAddress,
                );

                if (constraints.maxWidth >= 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: publicCard),
                      const SizedBox(width: 18),
                      Expanded(child: localCard),
                    ],
                  );
                }
                return Column(
                  children: [publicCard, const SizedBox(height: 18), localCard],
                );
              },
            ),
            const SizedBox(height: 18),
            _CopyAllBar(
              enabled: !_isLoading && _allAddresses.isNotEmpty,
              onPressed: _copyAll,
            ),
            const SizedBox(height: 26),
            const AdSenseBanner(placement: 'ip-address'),
            const SizedBox(height: 26),
            const _IpAddressGuide(),
          ],
        ),
      ),
    );
  }

  List<IpAddressInfo> get _allAddresses => [
    ...?_snapshot?.publicAddresses,
    ...?_snapshot?.localDiscovery.addresses,
  ];

  Future<void> _lookup() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }
    final snapshot = await _service.lookup();
    if (!mounted) {
      return;
    }
    setState(() {
      _snapshot = snapshot;
      _isLoading = false;
    });
  }

  String _localEmptyMessage(LocalIpDiscoveryState? state) {
    return switch (state) {
      LocalIpDiscoveryState.privacyProtected => '내부 IP가 브라우저에서 숨겨져 표시할 수 없습니다.',
      LocalIpDiscoveryState.unavailable => '현재 브라우저에서는 내부 IP를 자동으로 확인할 수 없습니다.',
      _ => '내부 IP를 확인하고 있습니다.',
    };
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('IP 주소를 복사했습니다.')));
  }

  Future<void> _copyAll() async {
    final snapshot = _snapshot;
    if (snapshot == null) {
      return;
    }
    final lines = <String>[
      for (final address in snapshot.publicAddresses)
        '공인 ${address.version.label}: ${address.address}',
      for (final address in snapshot.localDiscovery.addresses)
        '내부 ${address.version.label}: ${address.address}',
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('확인된 IP 정보를 모두 복사했습니다.')));
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isLoading,
    required this.addresses,
    required this.emptyMessage,
    required this.onCopy,
    this.infoMessage,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLoading;
  final List<IpAddressInfo> addresses;
  final String emptyMessage;
  final String? infoMessage;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF64748B), height: 1.45),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const SizedBox(
                height: 82,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (addresses.isEmpty)
              _EmptyAddress(message: emptyMessage)
            else
              for (var index = 0; index < addresses.length; index++) ...[
                _AddressRow(address: addresses[index], onCopy: onCopy),
                if (index < addresses.length - 1) const SizedBox(height: 10),
              ],
            if (!isLoading && infoMessage != null) ...[
              const SizedBox(height: 14),
              StatusLine(
                icon: Icons.shield_outlined,
                color: const Color(0xFF0369A1),
                label: infoMessage!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address, required this.onCopy});

  final IpAddressInfo address;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.version.label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  address.address,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: '${address.version.label} 주소 복사',
            onPressed: () => onCopy(address.address),
            icon: const Icon(Icons.copy_outlined, size: 20),
          ),
        ],
      ),
    );
  }
}

class _EmptyAddress extends StatelessWidget {
  const _EmptyAddress({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: StatusLine(
        icon: Icons.info_outline,
        color: const Color(0xFF92400E),
        label: message,
      ),
    );
  }
}

class _CopyAllBar extends StatelessWidget {
  const _CopyAllBar({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                '확인된 주소를 문서나 네트워크 설정에 바로 붙여 넣을 수 있습니다.',
                style: TextStyle(color: Color(0xFF475569)),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: enabled ? onPressed : null,
              icon: const Icon(Icons.copy_all_outlined),
              label: const Text('모두 복사'),
            ),
          ],
        ),
      ),
    );
  }
}

class _IpAddressGuide extends StatelessWidget {
  const _IpAddressGuide();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '알아두세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 16),
            _GuideItem(
              icon: Icons.router_outlined,
              title: '내부 IP와 공인 IP가 다른 이유',
              body:
                  '공유기는 각 기기에 내부 IP를 할당하고, 여러 기기가 하나의 공인 IP를 함께 사용하도록 주소를 변환합니다.',
            ),
            _GuideItem(
              icon: Icons.shield_outlined,
              title: '내부 IP가 표시되지 않을 수 있어요',
              body:
                  'Chrome, Safari, Firefox 등 최신 브라우저는 추적 방지를 위해 내부 IP를 숨기거나 임시 mDNS 주소로 바꿀 수 있습니다.',
            ),
            _GuideItem(
              icon: Icons.vpn_lock_outlined,
              title: 'VPN과 모바일 네트워크',
              body:
                  'VPN, 프록시, 통신사 네트워크를 사용하면 여기에 표시되는 공인 IP가 실제 회선 또는 공유기 주소와 다를 수 있습니다.',
              showBottomPadding: false,
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
    this.showBottomPadding = true,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool showBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showBottomPadding ? 18 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
