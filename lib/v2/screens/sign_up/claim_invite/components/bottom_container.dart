import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/claim_code.i18n.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/quadstate_clipboard_icon_button.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/utils/debouncer.dart';
import 'package:seeds/v2/utils/helpers.dart';

class BottomContainer extends StatefulWidget {
  const BottomContainer();

  @override
  _BottomContainerState createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer> {
  late SignupBloc _signupBloc;
  final _keyController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
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
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previousState, currentState) => previousState != currentState,
      listener: (context, state) {
        if (state.claimInviteState.pageState == PageState.success &&
            !state.claimInviteState.inviteMnemonic.isNullOrEmpty) {
          _keyController.text = state.claimInviteState.inviteMnemonic!;
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        buildWhen: (previousState, currentState) => previousState != currentState,
        builder: (context, state) => Container(
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
                    errorText: state.claimInviteState.pageState == PageState.failure
                        ? state.claimInviteState.errorMessage
                        : null,
                    suffixIcon: QuadStateClipboardIconButton(
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
                      isChecked: _signupBloc.state.claimInviteState.isValid,
                      canClear: !_signupBloc.state.claimInviteState.isValid && _keyController.text.isNotEmpty,
                      isLoading: _signupBloc.state.claimInviteState.isLoading,
                    ),
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
        ),
      ),
    );
  }

  void _onInviteCodeChanged() {
    if (_keyController.text.isNotEmpty) {
      _debouncer.run(() {
        _signupBloc.add(ValidateInviteCode(inviteCode: _keyController.text));
      });
    }
  }

  VoidCallback? _onClaimPressed(BuildContext context) => _signupBloc.state.claimInviteState.isValid
      ? () {
          FocusScope.of(context).unfocus();
          _signupBloc.add(NavigateToDisplayName());
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
