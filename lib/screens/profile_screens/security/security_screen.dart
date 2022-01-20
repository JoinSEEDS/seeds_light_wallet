import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/security/components/biometric_enabled_dialog.dart';
import 'package:seeds/screens/profile_screens/security/components/guardian_security_card.dart';
import 'package:seeds/screens/profile_screens/security/components/security_card.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';
import 'package:share/share.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localization.securityTitle)),
      body: BlocProvider(
        create: (context) =>
            SecurityBloc(BlocProvider.of<AuthenticationBloc>(context))..add(const SetUpInitialValues()),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SecurityBloc, SecurityState>(
              listenWhen: (_, current) => current.navigateToGuardians != null,
              listener: (context, _) => NavigationService.of(context).navigateTo(Routes.guardianTabs),
            ),
            BlocListener<SecurityBloc, SecurityState>(
              listenWhen: (_, current) => current.navigateToVerification != null,
              listener: (context, _) {
                BlocProvider.of<SecurityBloc>(context).add(const ResetNavigateToVerification());
                NavigationService.of(context).navigateTo(Routes.verification, BlocProvider.of<SecurityBloc>(context));
              },
            ),
            BlocListener<SecurityBloc, SecurityState>(
              listenWhen: (previous, current) =>
                  previous.isSecureBiometric == false && current.isSecureBiometric == true,
              listener: (context, _) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const BiometricEnabledDialog(),
                );
              },
            ),
          ],
          child: BlocBuilder<SecurityBloc, SecurityState>(
            buildWhen: (previous, current) => previous.pageState != current.pageState,
            builder: (context, state) {
              switch (state.pageState) {
                case PageState.initial:
                  return const SizedBox.shrink();
                case PageState.loading:
                  return const FullPageLoadingIndicator();
                case PageState.failure:
                  return const FullPageErrorIndicator();
                case PageState.success:
                  return SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        SecurityCard(
                          icon: const Icon(Icons.update),
                          title: localization.securityExportPrivateKeyTitle,
                          description: localization.securityExportPrivateKeyDescription,
                          onTap: () => Share.share(settingsStorage.privateKey!),
                        ),
                        BlocBuilder<SecurityBloc, SecurityState>(
                          buildWhen: (previous, current) =>
                              previous.hasNotification != current.hasNotification ||
                              previous.guardiansStatus != current.guardiansStatus,
                          builder: (context, state) {
                            return GuardianSecurityCard(
                              onTap: () => BlocProvider.of<SecurityBloc>(context)..add(const OnGuardiansCardTapped()),
                              hasNotification: state.hasNotification,
                              guardiansStatus: state.guardiansStatus,
                            );
                          },
                        ),
                        if (state.shouldShowExportRecoveryPhrase)
                          SecurityCard(
                            icon: const Icon(Icons.insert_drive_file),
                            title: localization.security12WordRecoveryPhraseTitle,
                            description: localization.security12WordRecoveryPhraseDescription,
                            onTap: () {
                              NavigationService.of(context).navigateTo(Routes.recoveryPhrase);
                            },
                          )
                        else
                          const SizedBox.shrink(),
                        SecurityCard(
                          icon: const Icon(Icons.lock_outline),
                          title: localization.securitySecureWithPinTitle,
                          titleWidget: BlocBuilder<SecurityBloc, SecurityState>(
                            buildWhen: (previous, current) => previous.isSecurePasscode != current.isSecurePasscode,
                            builder: (context, state) {
                              return Switch(
                                value: state.isSecurePasscode!,
                                onChanged: (_) =>
                                    BlocProvider.of<SecurityBloc>(context)..add(const OnPasscodePressed()),
                                activeTrackColor: AppColors.canopy,
                                activeColor: AppColors.white,
                              );
                            },
                          ),
                          description: localization.securitySecureWithPinDescription,
                        ),
                        SecurityCard(
                          icon: const Icon(Icons.fingerprint),
                          title: localization.securitySecureWithTouchFaceIDTitle,
                          titleWidget: BlocBuilder<SecurityBloc, SecurityState>(
                            builder: (context, state) {
                              return Switch(
                                value: state.isSecureBiometric!,
                                onChanged: state.isSecurePasscode!
                                    ? (_) {
                                        BlocProvider.of<SecurityBloc>(context).add(const OnBiometricPressed());
                                      }
                                    : null,
                                activeTrackColor: AppColors.canopy,
                                activeColor: AppColors.white,
                              );
                            },
                          ),
                          description: localization.securitySecureWithTouchFaceIDDescription,
                        ),
                      ],
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
