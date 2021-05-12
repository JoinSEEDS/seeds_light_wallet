import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/claim_code.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/signup_bloc.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/scanner/scanner_widget.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/utils/debouncer.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignupBloc _signupBloc;
  late ClaimInviteState _currentState;
  final _keyController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _currentState = _signupBloc.state.claimInviteState;
    _keyController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<SignupBloc, SignupState>(
        listenWhen: (previousState, currentState) =>
            previousState != currentState,
        listener: (context, state) {
          _currentState = state.claimInviteState;

          if (_currentState.pageState == PageState.success &&
              _currentState.inviteMnemonic != null &&
              _currentState.inviteMnemonic!.isNotEmpty) {
            _keyController.text = _currentState.inviteMnemonic!;
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'Scan QR Code',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  ScannerWidget(resultCallBack: _onQRScanned),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildBottomContainer(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.whiteYellow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Or enter by yourself below',
              style: Theme.of(context).accentTextTheme.subtitle2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _keyController,
              style: Theme.of(context).accentTextTheme.bodyText1,
              onChanged: _onInviteCodeChanged,
              decoration: InputDecoration(
                hintText: 'Invite code (5 words)'.i18n,
                hintStyle: Theme.of(context).accentTextTheme.bodyText1,
                errorText: _currentState.pageState == PageState.failure
                    ? _currentState.errorMessage
                    : null,
                suffixIcon: _inviteCodeSuffixIcon,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            FlatButtonLong(
              title: "Claim code".i18n,
              onPressed: _onClaimPressed(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _inviteCodeSuffixIcon {
    return _currentState.pageState == PageState.success &&
            _currentState.inviteModel != null
        ? const Icon(
            Icons.check_circle,
            color: AppColors.green,
          )
        : IconButton(
            icon: const Icon(
              Icons.paste,
              color: AppColors.grey,
            ),
            onPressed: () async {
              var clipboardData = await Clipboard.getData('text/plain');
              var clipboardText = clipboardData?.text ?? '';
              setState(() {
                _keyController.text = clipboardText;
              });
            },
          );
  }

  void _onInviteCodeChanged(String value) {
    if (value.isNotEmpty) {
      _debouncer.run(() {
        _signupBloc.add(ValidateInviteCode(inviteCode: value));
      });
    }
  }

  void _onQRScanned(String scannedLink) {
    _signupBloc.add(UnpackScannedLink(scannedLink));
  }

  VoidCallback? _onClaimPressed(BuildContext context) {
    final bool isValid = _currentState.pageState == PageState.success &&
        _currentState.inviteModel != null &&
        _currentState.inviteMnemonic != null;

    return isValid
        ? () {
            FocusScope.of(context).unfocus();
            NavigationService.of(context).navigateTo(Routes.displayName);
          }
        : null;
  }
}
