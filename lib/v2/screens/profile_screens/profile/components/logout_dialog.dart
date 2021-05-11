import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return CustomDialog(
          icon: SvgPicture.asset("assets/images/profile/logout_icon.svg"),
          children: [
            Text('Logout'.i18n, style: Theme.of(context).textTheme.button1Black),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(
                    'Save private key in secure place - to be able to restore access to your wallet later'.i18n,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2Darkgreen1L,
                  ),
                  const SizedBox(height: 36.0),
                  FlatButtonLong(
                    title: 'Save private key'.i18n,
                    onPressed: () => BlocProvider.of<ProfileBloc>(context).add(const OnSavePrivateKeyButtonPressed()),
                  ),
                  const SizedBox(height: 10.0),
                  if (state.showLogoutButton)
                    FlatButtonLong(
                      title: 'Logout'.i18n,
                      onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(const OnLogout()),
                      color: AppColors.white,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
