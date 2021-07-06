

import 'package:flutter/material.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';

class Wallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationService.of(context).walletNavigatorKey,
      initialRoute: Routes.wallet,
      onGenerateRoute: NavigationService.of(context).onGenerateRoute,
    );
  }
}
