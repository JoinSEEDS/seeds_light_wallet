import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/v2/components/scanner/scanner_widget.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/components/bottom_container.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';

class ClaimInviteScreen extends StatefulWidget {
  @override
  _ClaimInviteScreenState createState() => _ClaimInviteScreenState();
}

class _ClaimInviteScreenState extends State<ClaimInviteScreen> {
  late SignupBloc _signupBloc;
  late ClaimInviteState _currentState;

  late ScannerWidget _scannerWidget;

  @override
  void initState() {
    super.initState();
    _scannerWidget = ScannerWidget(resultCallBack: _onQRScanned);
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _currentState = _signupBloc.state.claimInviteState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: BlocListener<SignupBloc, SignupState>(
        listenWhen: (previousState, currentState) => previousState != currentState,
        listener: (context, state) {
          _currentState = state.claimInviteState;

          if (_currentState.pageState == PageState.success && !_currentState.inviteMnemonic.isNullOrEmpty) {
            _scannerWidget.stop();
          }

          if (_currentState.pageState == PageState.failure) {
            _scannerWidget.scan();
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          buildWhen: (previousState, currentState) => previousState != currentState,
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraint) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(child: _scannerWidget),
                        const SizedBox(
                          height: 30,
                        ),
                        const BottomContainer(),
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
    _signupBloc.add(UnpackScannedLink(scannedLink));
  }
}
