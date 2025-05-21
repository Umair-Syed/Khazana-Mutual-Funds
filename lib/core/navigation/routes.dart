import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home('/'),
  auth('/auth'),
  charts('/charts'),
  wishlist('/wishlist'),
  fundDetails('/fund-details');

  const AppRoute(this.path);

  final String path;
}

extension AppRouteNavigation on AppRoute {
  void go(BuildContext context) => context.go(path);

  void push(BuildContext context) => context.push(path);
}
