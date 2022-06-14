import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/flat_button_long_outlined.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/utils/build_context_extension.dart';

const int _approxWidgetHeight = 450;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
          onPressed: () {
            if (settingsStorage.inRecoveryMode) {
              NavigationService.of(context).navigateTo(Routes.recoverAccountFound, settingsStorage.accountName);
            } else {
              NavigationService.of(context).navigateTo(Routes.recoverAccountSearch);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.loc.loginRecoverAccountActionSegment1, style: Theme.of(context).textTheme.subtitle2),
              Text(context.loc.loginRecoverAccountActionLink,
                  style: Theme.of(context).textTheme.subtitle2HighEmphasisGreen1),
              Text(context.loc.loginRecoverAccountActionSegment2, style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: max(0, min(height * 0.4, height - _approxWidgetHeight)),
                decoration: const BoxDecoration(
                  image: DecorationImage(fit: BoxFit.fitWidth, image: AssetImage("assets/images/login/background.png")),
                ),
              ),
              SvgPicture.asset("assets/images/login/seeds_light_wallet_logo.svg"),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.loc.loginFirstTimeHere, style: Theme.of(context).textTheme.subtitle2),
                    const SizedBox(height: 10),
                    FlatButtonLong(
                      onPressed: () => NavigationService.of(context).navigateTo(Routes.signup),
                      title: context.loc.loginClaimInviteCodeButtonTitle,
                    ),
                    const SizedBox(height: 40),
                    Text(context.loc.loginAlreadyHaveAnAccount, style: Theme.of(context).textTheme.subtitle2),
                    const SizedBox(height: 10),
                    FlatButtonLongOutlined(
                      onPressed: () {
                        /// We use remoteConfigurations directly here because this page doesnt have blocs.
                        /// !!!Please do not copy this pattern!!!
                        if (remoteConfigurations.featureFlagExportRecoveryPhraseEnabled) {
                          NavigationService.of(context).navigateTo(Routes.importWords);
                        } else {
                          NavigationService.of(context).navigateTo(Routes.importKey);
                        }
                      },
                      title: context.loc.loginImportAccountButtonTitle,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
