import 'package:flutter/material.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

import '../routes/navigation.dart';
import '../routes/site_route.dart';

class SiteAppBar extends StatelessWidget {
  const SiteAppBar({super.key, required this.currentRoute});

  final SiteRoute currentRoute;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 640;

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withValues(alpha: 0.94),
      surfaceTintColor: Colors.white,
      titleSpacing: isCompact ? 12 : null,
      title: SizedBox(
        width: isCompact ? 144 : 180,
        height: 36,
        child: TextButton(
          onPressed: () => goToRoute(context, SiteRoute.home),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0F172A),
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            textStyle: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          child: SizeTailoredTextWidget(
            'AQoong.dev',
            maxLines: 1,
            minFontSize: 15,
            overflow: TextOverflow.clip,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ),
      actions: isCompact
          ? [
              _CompactNavigationMenu(currentRoute: currentRoute),
              const SizedBox(width: 8),
            ]
          : [
              _NavLink(route: SiteRoute.packages, selected: currentRoute),
              _NavLink(route: SiteRoute.jsonParser, selected: currentRoute),
              _NavLink(route: SiteRoute.guide, selected: currentRoute),
              _NavLink(route: SiteRoute.about, selected: currentRoute),
              const SizedBox(width: 16),
            ],
    );
  }
}

class _CompactNavigationMenu extends StatelessWidget {
  const _CompactNavigationMenu({required this.currentRoute});

  final SiteRoute currentRoute;

  @override
  Widget build(BuildContext context) {
    const menuRoutes = [
      SiteRoute.packages,
      SiteRoute.jsonParser,
      SiteRoute.guide,
      SiteRoute.about,
    ];

    return PopupMenuButton<SiteRoute>(
      tooltip: 'Open navigation',
      icon: const Icon(Icons.menu_rounded),
      onSelected: (route) => goToRoute(context, route),
      itemBuilder: (context) {
        return [
          for (final route in menuRoutes)
            PopupMenuItem<SiteRoute>(
              value: route,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 22,
                      child: SizeTailoredTextWidget(
                        route.label,
                        maxLines: 1,
                        minFontSize: 12,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  if (route == currentRoute)
                    Icon(
                      Icons.check_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
            ),
        ];
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.route, required this.selected});

  final SiteRoute route;
  final SiteRoute selected;

  @override
  Widget build(BuildContext context) {
    final isSelected = route == selected;

    return TextButton(
      onPressed: () => goToRoute(context, route),
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF334155),
        backgroundColor: isSelected ? const Color(0xFFEFF6FF) : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(
            color: isSelected ? const Color(0xFFBFDBFE) : Colors.transparent,
          ),
        ),
        textStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      child: SizedBox(
        height: 20,
        child: SizeTailoredTextWidget(
          route.label,
          maxLines: 1,
          minFontSize: 11,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
