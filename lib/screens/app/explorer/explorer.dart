import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';

class Explorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationService.of(context).explorerNavigatorKey,
      initialRoute: Routes.overview,
      onGenerateRoute: NavigationService.of(context).onGenerateRoute,
    );
  }
}
