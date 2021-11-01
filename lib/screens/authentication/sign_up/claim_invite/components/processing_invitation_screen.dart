import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/authentication/sign_up/sign_up.i18n.dart';
import 'package:seeds/images/signup/claim_invite/invite_link_success.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/states/claim_invite_state.dart';

class ProcessingInvitationScreen extends StatelessWidget {
  final ClaimInviteView view;
  const ProcessingInvitationScreen(this.view, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                if (view == ClaimInviteView.processing)
                  Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.green1),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Processing your invitation...'.i18n,
                        style: Theme.of(context).textTheme.headline7,
                      )
                    ],
                  ),
                if (view == ClaimInviteView.success)
                  Column(
                    children: [
                      const CustomPaint(
                        size: Size(70, 70),
                        painter: InviteLinkSuccess(),
                      ),
                      const SizedBox(height: 30),
                      Text('Success!'.i18n, style: Theme.of(context).textTheme.headline7),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
