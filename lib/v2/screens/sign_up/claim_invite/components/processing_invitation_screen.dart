import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/images/signup/claim_invite/invite_link_success.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';

class ProcessingInvitationScreen extends StatelessWidget {
  final ClaimInviteView view;
  const ProcessingInvitationScreen(this.view, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                        const CircularProgressIndicator(color: AppColors.green1),
                        const SizedBox(height: 30),
                        Text(
                          'Processing your invitation...',
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
                        Text('Success!', style: Theme.of(context).textTheme.headline7),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
