import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/screens/verification/components/create_passcode.dart';
import 'package:seeds/v2/screens/verification/components/verify_passcode.dart';
import 'package:seeds/v2/screens/verification/interactor/viewmodels/bloc.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _securityBloc = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
      create: (context) => VerificationBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context), securityBloc: _securityBloc)
        ..add(const InitVerification()),
      child: Scaffold(
        body: BlocBuilder<VerificationBloc, VerificationState>(
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return state.isCreateView ? const CreatePasscode() : const VerifyPasscode();
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
