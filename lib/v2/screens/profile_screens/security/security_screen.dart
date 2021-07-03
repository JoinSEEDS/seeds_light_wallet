import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/i18n/security.i18n.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/notification_badge.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/security/components/security_card.dart';
import 'package:seeds/v2/screens/profile_screens/security/components/biometric_enabled_dialog.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';
import 'package:share/share.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Security'.i18n)),
      body: BlocProvider(
        create: (context) => SecurityBloc(authenticationBloc: BlocProvider.of<AuthenticationBloc>(context))
          ..add(const SetUpInitialValues()),
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
              listener: (context, state) {
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
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      SecurityCard(
                        icon: const Icon(Icons.update),
                        title: 'Export Private Key'.i18n,
                        description: 'Export your private key so you can easily recover and access your account.'.i18n,
                        onTap: () => Share.share(settingsStorage.privateKey!),
                      ),
                      BlocBuilder<SecurityBloc, SecurityState>(
                        buildWhen: (previous, current) => previous.hasNotification != current.hasNotification,
                        builder: (context, state) {
                          return Stack(
                            children: [
                              SecurityCard(
                                icon: SvgPicture.asset('assets/images/security/key_guardians_icon.svg'),
                                title: 'Key Guardians'.i18n,
                                description:
                                    'Choose 3 - 5 friends and/or family members to help you recover your account in case.'
                                        .i18n,
                                onTap: () => BlocProvider.of<SecurityBloc>(context)..add(const OnGuardiansCardTapped()),
                              ),
                              if (state.hasNotification) const Positioned(left: 4, top: 10, child: NotificationBadge())
                            ],
                          );
                        },
                      ),
                      SecurityCard(
                        icon: const Icon(Icons.lock_outline),
                        title: 'Secure with Pin'.i18n,
                        titleWidget: BlocBuilder<SecurityBloc, SecurityState>(
                          buildWhen: (previous, current) => previous.isSecurePasscode != current.isSecurePasscode,
                          builder: (context, state) {
                            return Switch(
                              value: state.isSecurePasscode!,
                              onChanged: (_) => BlocProvider.of<SecurityBloc>(context)..add(const OnPasscodePressed()),
                              activeTrackColor: AppColors.canopy,
                              activeColor: AppColors.white,
                            );
                          },
                        ),
                        description: 'Secure your account with a 6-digit pincode'.i18n,
                      ),
                      SecurityCard(
                        icon: const Icon(Icons.fingerprint),
                        title: 'Secure with Touch/Face ID'.i18n,
                        titleWidget: BlocBuilder<SecurityBloc, SecurityState>(
                          builder: (context, state) {
                            return Switch(
                              value: state.isSecureBiometric!,
                              onChanged: state.isSecurePasscode!
                                  ? (_) {
                                      BlocProvider.of<SecurityBloc>(context)..add(const OnBiometricPressed());
                                    }
                                  : null,
                              activeTrackColor: AppColors.canopy,
                              activeColor: AppColors.white,
                            );
                          },
                        ),
                        description:
                            'Secure your account with your fingerprint. This will be used to sign-in and open your wallet.'
                                .i18n,
                      ),
                    ],
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
