import 'package:flutter/material.dart';

import 'site_route.dart';
import 'site_router.dart';

void goToRoute(BuildContext context, SiteRoute route) {
  final delegate = Router.of(context).routerDelegate;

  if (delegate is SiteRouterDelegate) {
    if (delegate.currentConfiguration == route) {
      return;
    }

    Router.navigate(context, () => delegate.go(route));
    return;
  }

  Navigator.of(context).pushNamed(route.path);
}
