import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/notification_badge.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class GuardianSecurityCard extends StatelessWidget {
  final GuardiansStatus? guardiansStatus;
  final GestureTapCallback? onTap;
  final bool hasNotification;

  const GuardianSecurityCard({super.key, this.guardiansStatus, this.onTap, this.hasNotification = false});

  @override
  Widget build(BuildContext context) {
    Widget guardianStatus;
    switch (guardiansStatus) {
      case GuardiansStatus.active:
        guardianStatus =
            Text(context.loc.securityGuardiansStatusActive, style: const TextStyle(color: AppColors.green1));
        break;
      case GuardiansStatus.inactive:
        guardianStatus =
            Text(context.loc.securityGuardiansStatusInactive, style: const TextStyle(color: AppColors.red));
        break;
      case GuardiansStatus.readyToActivate:
        guardianStatus =
            Text(context.loc.securityGuardiansStatusReadyToActivate, style: const TextStyle(color: AppColors.orange));
        break;
      default:
        guardianStatus = Container(height: 16, width: 16, child: const Center(child: CircularProgressIndicator()));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.darkGreen2,
            borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 8.0),
                    child: SvgPicture.asset('assets/images/security/key_guardians_icon.svg'),
                  ),
                ],
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      context.loc.securityGuardiansHeader,
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (hasNotification) const NotificationBadge()
                                ],
                              ),
                            ),
                          ),
                          guardianStatus
                        ],
                      ),
                      const DividerJungle(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                context.loc.securityGuardiansDescription,
                                style: Theme.of(context).textTheme.subtitle3,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
