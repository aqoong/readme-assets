import 'package:flutter/material.dart';

import '../routes/navigation.dart';
import '../routes/site_route.dart';

class SiteAppBar extends StatelessWidget {
  const SiteAppBar({super.key, required this.currentRoute});

  final SiteRoute currentRoute;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withValues(alpha: 0.94),
      surfaceTintColor: Colors.white,
      title: TextButton(
        onPressed: () => goToRoute(context, SiteRoute.home),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF0F172A),
          padding: EdgeInsets.zero,
          textStyle: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        child: const Text('AQoong.dev'),
      ),
      actions: [
        _NavLink(route: SiteRoute.packages, selected: currentRoute),
        _NavLink(route: SiteRoute.jsonParser, selected: currentRoute),
        _NavLink(route: SiteRoute.guide, selected: currentRoute),
        _NavLink(route: SiteRoute.about, selected: currentRoute),
        const SizedBox(width: 16),
      ],
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
      child: Text(route.label),
    );
  }
}
