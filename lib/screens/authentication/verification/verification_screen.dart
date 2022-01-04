import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/verification/components/create_passcode.dart';
import 'package:seeds/screens/authentication/verification/components/verify_passcode.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_bloc.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_event.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_state.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecurityBloc? _securityBloc = ModalRoute.of(context)!.settings.arguments as SecurityBloc?;
    return BlocProvider(
      create: (context) => VerificationBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context), securityBloc: _securityBloc)
        ..add(const InitVerification()),
      child: WillPopScope(
        // User can only pop without auth if it is on security screen
        onWillPop: () async => _securityBloc != null,
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<VerificationBloc, VerificationState>(
              builder: (context, state) {
                switch (state.pageState) {
                  case PageState.initial:
                    return const SizedBox.shrink();
                  case PageState.loading:
                    return const FullPageLoadingIndicator();
                  case PageState.failure:
                    return const FullPageErrorIndicator();
                  case PageState.success:
                    return state.isCreateView! ? const CreatePasscode() : const VerifyPasscode();
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
