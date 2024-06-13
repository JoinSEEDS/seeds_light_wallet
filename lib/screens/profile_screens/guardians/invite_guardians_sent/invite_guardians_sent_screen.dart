import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';

class InviteGuardiansSentScreen extends StatelessWidget {
  const InviteGuardiansSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const SizedBox.shrink()),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context, ModalRoute.withName(Routes.guardianTabs));
          return true;
        },
        child: SafeArea(
          minimum: const EdgeInsets.all(horizontalEdgePadding),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Icon(Icons.check_circle, size: 120, color: AppColors.lightGreen5),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Invites Sent!".i18n,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButtonLong(
                    title: 'Ok'.i18n,
                    onPressed: () => {
                      Navigator.popUntil(context, ModalRoute.withName('app')),
                      NavigationService.of(context).navigateTo(Routes.security),
                      NavigationService.of(context).navigateTo(Routes.guardianTabs)
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
