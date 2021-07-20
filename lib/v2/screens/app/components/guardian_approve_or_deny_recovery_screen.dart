import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/components/custom_dialog.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class GuardianApproveOrDenyScreen extends StatelessWidget {
  const GuardianApproveOrDenyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: CustomDialog(
          children: [
            Container(
              height: 200,
              width: 250,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/guardians/guardian_shield.png',
                    ),
                    fit: BoxFit.fitWidth),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Guardian TODONAME would like to reset their private key. You as their guardian can approve or deny this request. Only approve this request if you are 100% sure its a valid request ',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Approve this guardian reset request?',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
          leftButtonTitle: 'Do NOT Approve',
          rightButtonTitle: 'Approve Recovery',
          onLeftButtonPressed: () {
            // TODO(gguij002): Next PR
          },
          onRightButtonPressed: () {
            // TODO(gguij002): Next PR
          },
        ),
      ),
    );
  }
}
