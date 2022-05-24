import 'package:flutter/cupertino.dart';

/// Define the widget used in polkawallet app home page.
class HomeNavItem {
  HomeNavItem({
    required this.text,
    required this.content,
    this.icon,
    this.iconActive,
    this.isAdapter = false,
    this.onTap,
  });

  /// Text display in BottomNavBar.
  final String text;

  /// Icon display in BottomNavBar(Have been abandoned).
  final Widget? icon;

  /// Icon display in BottomNavBar(Have been abandoned).
  final Widget? iconActive;

  /// Page content for this nav item.
  final Widget content;

  /// V3 adapter
  final bool isAdapter;

  /// isAdapter=false&&Items.length>1 , To come into force
  Function()? onTap;
}
