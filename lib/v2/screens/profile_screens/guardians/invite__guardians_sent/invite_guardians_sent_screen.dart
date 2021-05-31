import 'package:flutter/material.dart';
import 'package:seeds/i18n/guardians.i18n.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';

class InviteGuardiansSentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.popUntil(context, ModalRoute.withName(Routes.guardianTabs));
            return true;
          },
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                  child: const Icon(
                Icons.check_circle,
                size: 120,
                color: AppColors.lightGreen5,
              )),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Invites Sent!".i18n,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                    child: FlatButtonLong(
                      title: 'Ok'.i18n,
                      onPressed: () => {
                        Navigator.popUntil(context, ModalRoute.withName('/')),
                        NavigationService.of(context).navigateTo(Routes.security),
                        NavigationService.of(context).navigateTo(Routes.guardianTabs)
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }
}
