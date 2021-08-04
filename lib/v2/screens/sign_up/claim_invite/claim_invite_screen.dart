import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/scanner/scanner_widget.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/i18n/sign_up/claim_invite.i18n.dart';

class ClaimInviteScreen extends StatefulWidget {
  const ClaimInviteScreen({Key? key}) : super(key: key);

  @override
  _ClaimInviteScreenState createState() => _ClaimInviteScreenState();
}

class _ClaimInviteScreenState extends State<ClaimInviteScreen> {
  late SignupBloc _signupBloc;
  late ScannerWidget _scannerWidget;

  @override
  void initState() {
    super.initState();
    _scannerWidget = ScannerWidget(resultCallBack: _onQRScanned);
    _signupBloc = BlocProvider.of<SignupBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code'.i18n)),
      body: BlocListener<SignupBloc, SignupState>(
        listenWhen: (previousState, currentState) => previousState != currentState, // <--on every state change??
        listener: (context, state) {
          if (state.claimInviteState.pageCommand is StopScan) {
            _scannerWidget.stop();
          }

          if (state.claimInviteState.pageCommand is StartScan) {
            _scannerWidget.scan();
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraint) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: _scannerWidget),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onQRScanned(String scannedLink) {
    _scannerWidget.showLoading();
    _signupBloc.add(OnQRScanned(scannedLink));
  }
}
