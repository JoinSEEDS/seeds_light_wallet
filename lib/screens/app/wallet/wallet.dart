

import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';

class Wallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationService.of(context).walletNavigatorKey,
      initialRoute: Routes.dashboard,
      onGenerateRoute: NavigationService.of(context).onGenerateRoute,
    );
  }
}
