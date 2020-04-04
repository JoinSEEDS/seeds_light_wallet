import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';

class Ecosystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationService.of(context).ecosystemNavigatorKey,
      initialRoute: Routes.overview,
      onGenerateRoute: NavigationService.of(context).onGenerateRoute,
    );
  }
}
