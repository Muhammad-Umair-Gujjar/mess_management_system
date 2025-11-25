import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String title;
  final String route;
  final int? badge;

  const NavigationItem({
    required this.icon,
    required this.title,
    required this.route,
    this.badge,
  });
}




