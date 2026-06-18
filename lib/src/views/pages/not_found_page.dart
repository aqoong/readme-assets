import 'package:flutter/material.dart';

import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/footer_section.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      currentRoute: SiteRoute.notFound,
      children: [
        SectionBand(
          child: ConstrainedSection(
            id: 'not-found',
            title: '404 - Page not found',
            subtitle:
                'The address does not match a page in the current AQoong.dev route catalog.',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton(
                  onPressed: () => goToRoute(context, SiteRoute.home),
                  child: const Text('Home'),
                ),
                OutlinedButton(
                  onPressed: () => goToRoute(context, SiteRoute.packages),
                  child: const Text('Packages'),
                ),
                OutlinedButton(
                  onPressed: () => goToRoute(context, SiteRoute.jsonParser),
                  child: const Text('JSON Parser'),
                ),
                OutlinedButton(
                  onPressed: () => goToRoute(context, SiteRoute.articles),
                  child: const Text('Articles'),
                ),
              ],
            ),
          ),
        ),
        const FooterSection(),
      ],
    );
  }
}
