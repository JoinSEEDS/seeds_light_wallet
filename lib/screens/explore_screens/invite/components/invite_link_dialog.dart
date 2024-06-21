import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/qr_code_generator_widget.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:share/share.dart';

class InviteLinkDialog extends StatefulWidget {
  const InviteLinkDialog({super.key});

  @override
  State<InviteLinkDialog> createState() => _InviteLinkDialogState();
}

class _InviteLinkDialogState extends State<InviteLinkDialog> {
  bool _showCloseDialogButton = false;

  @override
  Widget build(BuildContext context) {
    // Here you can only have read access to the last of the bloc state,
    // you cannot perform write operations on this passed bloc (is dead),
    // because it no longer exists (invite screen was popped)
    return BlocBuilder<InviteBloc, InviteState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: Center(
            child: SingleChildScrollView(
              child: CustomDialog(
                icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
                rightButtonTitle: context.loc.inviteLinkDialogRightButtonTitle,
                leftButtonTitle: _showCloseDialogButton ? context.loc.genericCloseButtonTitle : '',
                onRightButtonPressed: () async {
                  setState(() => _showCloseDialogButton = true);
                  await Share.share(state.dynamicSecretLink!);
                },
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.tokenAmount.amountString(), style: Theme.of(context).textTheme.headlineMedium),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 4),
                        child: Text(state.tokenAmount.symbol, style: Theme.of(context).textTheme.titleSmall),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(state.fiatAmount.asFormattedString(), style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 20.0),
                  QrCodeGeneratorWidget(data: state.dynamicSecretLink!, size: 254),
                  const SizedBox(height: 20.0),
                  Text(
                    context.loc.inviteLinkDialogMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
