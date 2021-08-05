import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/flat_button_long_outlined.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/i18n/login/login.i18n.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';

/// Login SCREEN
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
          onPressed: () {
            if (settingsStorage.inRecoveryMode) {
              NavigationService.of(context).navigateTo(
                Routes.recoverAccountFound,
                settingsStorage.accountName,
              );
            } else {
              NavigationService.of(context).navigateTo(Routes.recoverAccount);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Lost your key?".i18n, style: Theme.of(context).textTheme.subtitle2),
              Text(" Recover ".i18n, style: Theme.of(context).textTheme.subtitle2HighEmphasisGreen1),
              Text("your account here".i18n, style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/login/background.png"),
                ),
              ),
            ),
            SvgPicture.asset("assets/images/login/seeds_light_wallet_logo.svg"),
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("First time here?".i18n, style: Theme.of(context).textTheme.subtitle2),
                  const SizedBox(height: 10),
                  FlatButtonLong(
                    onPressed: () => NavigationService.of(context).navigateTo(Routes.signup),
                    title: "Claim invite code".i18n,
                  ),
                  const SizedBox(height: 40),
                  Text("Already have a Seeds Account?".i18n, style: Theme.of(context).textTheme.subtitle2),
                  const SizedBox(height: 10),
                  FlatButtonLongOutlined(
                    onPressed: () => NavigationService.of(context).navigateTo(Routes.importKey),
                    title: "Import private key".i18n,
                  )
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
