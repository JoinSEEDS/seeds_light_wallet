import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/claim_code.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/scanner/scanner_widget.dart';
import 'package:seeds/v2/components/quadstate_clipboard_icon_button.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/utils/debouncer.dart';
import 'package:seeds/v2/utils/helpers.dart';

class ClaimInviteScreen extends StatefulWidget {
  @override
  _ClaimInviteScreenState createState() => _ClaimInviteScreenState();
}

class _ClaimInviteScreenState extends State<ClaimInviteScreen> {
  late SignupBloc _signupBloc;
  late ClaimInviteState _currentState;
  final _keyController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  late ScannerWidget _scannerWidget;

  @override
  void initState() {
    super.initState();
    _scannerWidget = ScannerWidget(resultCallBack: _onQRScanned);
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    _currentState = _signupBloc.state.claimInviteState;
    _keyController.text = '';
    _keyController.addListener(_onInviteCodeChanged);
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
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
            _keyController.text = _currentState.inviteMnemonic!;
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
                        _buildBottomContainer(context),
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
              decoration: InputDecoration(
                hintText: 'Invite code (5 words)'.i18n,
                hintStyle: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                errorText: _currentState.pageState == PageState.failure ? _currentState.errorMessage : null,
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
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    width: 1,
                    color: AppColors.red,
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
    final bool isChecked = _currentState.pageState == PageState.success && _currentState.inviteModel != null;
    final bool canClear = !isChecked && _keyController.text.isNotEmpty;
    final bool loading = _currentState.pageState == PageState.loading;

    return QuadStateClipboardIconButton(
      onClear: () {
        setState(() {
          _keyController.text = '';
        });
      },
      onPaste: () async {
        final clipboardText = await getClipboardData();
        setState(() {
          _keyController.text = clipboardText;
        });
      },
      isChecked: isChecked,
      canClear: canClear,
      isLoading: loading,
    );
  }

  void _onInviteCodeChanged() {
    if (_keyController.text.isNotEmpty) {
      _debouncer.run(() {
        _signupBloc.add(ValidateInviteCode(inviteCode: _keyController.text));
      });
    }
  }

  void _onQRScanned(String scannedLink) {
    _scannerWidget.showLoading();
    _signupBloc.add(UnpackScannedLink(scannedLink));
  }

  VoidCallback? _onClaimPressed(BuildContext context) {
    final bool isValid = _currentState.pageState == PageState.success &&
        _currentState.inviteModel != null &&
        _currentState.inviteMnemonic != null;

    return isValid
        ? () {
            FocusScope.of(context).unfocus();
            _scannerWidget.stop();
            NavigationService.of(context).navigateTo(Routes.displayName);
          }
        : () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Please enter a valid invite code',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              backgroundColor: AppColors.red1,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ));
          };
  }
}
