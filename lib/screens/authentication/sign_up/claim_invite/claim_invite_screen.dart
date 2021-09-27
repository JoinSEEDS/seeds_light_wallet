import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_event.dart';
import 'package:seeds/components/scanner/scanner_widget.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/i18n/authentication/sign_up/sign_up.i18n.dart';
import 'package:seeds/screens/authentication/sign_up/claim_invite/components/invite_link_fail_dialog.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/bloc.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/states/claim_invite_state.dart';

import 'components/processing_invitation_screen.dart';

class ClaimInviteScreen extends StatefulWidget {
  const ClaimInviteScreen({Key? key}) : super(key: key);

  @override
  _ClaimInviteScreenState createState() => _ClaimInviteScreenState();
}

class _ClaimInviteScreenState extends State<ClaimInviteScreen> {
  late SignupBloc _signupBloc;
  late DeeplinkBloc _deeplinkBloc;
  late ScannerWidget _scannerWidget;

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _deeplinkBloc = BlocProvider.of<DeeplinkBloc>(context);
    _scannerWidget = ScannerWidget(resultCallBack: (scannedLink) => _signupBloc.add(OnQRScanned(scannedLink)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (_, current) => current.claimInviteState.pageCommand != null,
      listener: (context, state) async {
        final pageCommand = state.claimInviteState.pageCommand;
        _signupBloc.add(ClearClaimInvitePageCommand());
        if (pageCommand is StopScan) {
          _scannerWidget.stop();
        } else if (pageCommand is StartScan) {
          _scannerWidget.scan();
        } else if (pageCommand is ShowErrorMessage) {
          await showDialog<void>(
            barrierColor: Colors.transparent,
            context: context,
            builder: (_) => const InviteLinkFailDialog(),
          ).whenComplete(() => state.claimInviteState.fromDeepLink
              ? _deeplinkBloc.add(const ClearDeepLink())
              : _signupBloc.add(OnInvalidInviteDialogClosed()));
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          final view = state.claimInviteState.claimInviteView;
          switch (view) {
            case ClaimInviteView.initial:
              return const SizedBox.shrink();
            case ClaimInviteView.scanner:
              return Scaffold(appBar: AppBar(title: Text('Scan QR Code'.i18n)), body: _scannerWidget);
            case ClaimInviteView.processing:
            case ClaimInviteView.success:
            case ClaimInviteView.fail:
              return ProcessingInvitationScreen(view);
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
