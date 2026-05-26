import 'package:flutter/material.dart';

import 'site_route.dart';

void goToRoute(BuildContext context, SiteRoute route) {
  final current = ModalRoute.of(context)?.settings.name;
  if (current == route.path) {
    return;
  }
  Navigator.of(context).pushReplacementNamed(route.path);
}
