import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/scanner/scanner_widget.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/components/bottom_container.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';

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
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: BlocListener<SignupBloc, SignupState>(
        listenWhen: (previousState, currentState) => previousState != currentState,
        listener: (context, state) {
          if (state.claimInviteState.pageCommand is StopScan) {
            _scannerWidget.stop();
          }

          if (state.claimInviteState.pageCommand is StartScan) {
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
    _signupBloc.add(OnQRScanned(scannedLink));
  }
}
