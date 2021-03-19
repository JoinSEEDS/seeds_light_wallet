import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/i18n/security.i18n.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/notification_badge.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/security/components/security_card.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';
import 'package:share/share.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Security'.i18n)),
      body: BlocProvider(
        create: (context) => SecurityBloc(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SecurityBloc, SecurityState>(
              listenWhen: (previous, current) =>
                  previous.isSecureBiometric == false && current.isSecureBiometric == true,
              listener: (context, state) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button
                  builder: (_) => CustomDialog(
                    icon: const Icon(Icons.fingerprint, size: 52, color: AppColors.green1),
                    children: [
                      Text(
                        'Touch ID/ Face ID'.i18n,
                        style: Theme.of(context).textTheme.headline6.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'When Touch ID/Face ID has been set up, any biometric saved in your device will be able to login into the Seeds Light Wallet. You will not be able to use this feature for transactions.'
                            .i18n,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(color: AppColors.primary),
                      ),
                    ],
                    singleLargeButtonTitle: 'Got it, thanks!'.i18n,
                  ),
                );
              },
            )
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
                        onTap: () => Share.share(settingsStorage.privateKey),
                      ),
                      StreamBuilder<bool>(
                        stream: FirebaseDatabaseService().hasGuardianNotificationPending(settingsStorage.accountName),
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          if (snapshot != null && snapshot.hasData) {
                            return Stack(
                              children: [
                                SecurityCard(
                                  icon: SvgPicture.asset('assets/images/key_guardians_icon.svg'),
                                  title: 'Key Guardians'.i18n,
                                  description:
                                      'Choose 3 - 5 friends and/or family members to help you recover your account in case.'
                                          .i18n,
                                  onTap: () {
                                    if (snapshot.data) {
                                      FirebaseDatabaseService().removeGuardianNotification(settingsStorage.accountName);
                                    }
                                    NavigationService.of(context).navigateTo(Routes.guardianTabs);
                                  },
                                ),
                                Positioned(left: 4, top: 12, child: NotificationBadge(isVisible: snapshot.data))
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      SecurityCard(
                        icon: const Icon(Icons.lock_outline),
                        title: 'Secure with Pin'.i18n,
                        titleWidget: BlocBuilder<SecurityBloc, SecurityState>(
                          buildWhen: (previous, current) => previous.isSecurePin != current.isSecurePin,
                          builder: (context, state) {
                            return Switch(
                              value: state.isSecurePin,
                              onChanged: (_) {
                                BlocProvider.of<SecurityBloc>(context).add(const OnPinChanged());
                              },
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
                          buildWhen: (previous, current) => previous.isSecureBiometric != current.isSecureBiometric,
                          builder: (context, state) {
                            return Switch(
                              value: state.isSecureBiometric,
                              onChanged: (_) {
                                BlocProvider.of<SecurityBloc>(context).add(const OnBiometricsChanged());
                              },
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
