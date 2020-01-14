import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/onboarding/helpers.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/services/auth_service.dart';
import 'package:seeds/utils/config.dart';

import 'constants/custom_colors.dart';
import 'generated/r.dart';

main(List<String> args) async {
  // you could add more than one config file
  // files should be added to assets/config
  secretConfig = await Config.init('secret_config.json');

  runApp(SeedsApp());
}

class SeedsApp extends StatefulWidget {
  @override
  _SeedsAppState createState() => _SeedsAppState();
}

class _SeedsAppState extends State<SeedsApp> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return ToolboxApp(
      noItemsFoundWidget: Padding(
        padding: const EdgeInsets.all(32),
        child: SvgPicture.asset(R.noItemFound),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primary,
          tabBarTheme: TabBarTheme(
            indicator: TabRoundedLineIndicator(
              context,
              indicatorColor: primary,
            ),
          ),
        ),
        home: FutureBuilder(
          future: authService.initializedAccount(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return App(snapshot.data);
            }
            return Onboarding();
          },
        ),
      ),
    );
  }
}
