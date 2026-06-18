import 'package:flutter/material.dart';

import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../utils/open_url.dart';
import '../../widgets/common_widgets.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      backgroundColor: const Color(0xFF0F172A),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 14,
            children: [
              const SizedBox(
                width: 280,
                child: Text(
                  'AQoong.dev shares Flutter packages, Android libraries, and browser-only developer tools from aqoong.pe.kr.',
                  style: TextStyle(color: Colors.white, height: 1.45),
                ),
              ),
              _FooterButton(
                label: 'Flutter packages',
                onPressed: () => goToRoute(context, SiteRoute.packages),
              ),
              _FooterButton(
                label: 'Android libraries',
                onPressed: () => goToRoute(context, SiteRoute.packages),
              ),
              _FooterButton(
                label: 'GitHub',
                onPressed: () => openExternalUrl('https://github.com/aqoong'),
              ),
              _FooterButton(
                label: 'pub.dev',
                onPressed: () => openExternalUrl(
                  'https://pub.dev/publishers/aqoong.pe.kr/packages',
                ),
              ),
              _FooterButton(
                label: 'Privacy',
                onPressed: () => goToRoute(context, SiteRoute.privacy),
              ),
              Text(
                'Copyright 2026 AQoong',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      child: Text(label),
    );
  }
}
