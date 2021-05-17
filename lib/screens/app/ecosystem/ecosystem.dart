

import 'package:flutter/material.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';

class Ecosystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationService.of(context).ecosystemNavigatorKey,
      initialRoute: Routes.explore,
      onGenerateRoute: NavigationService.of(context).onGenerateRoute,
    );
  }
}
