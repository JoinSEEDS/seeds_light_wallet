import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/claim_invite_screen.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/screens/sign_up/display_name/display_name.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignupBloc(
        claimInviteUseCase: ClaimInviteUseCase(
          signupRepository: SignupRepository(),
        ),
      ),
      child: BlocBuilder<SignupBloc, SignupState>(
        buildWhen: (previous, current) => previous.pageContent != current.pageContent,
        builder: (context, state) {
          final PageContent pageContent = state.pageContent;

          switch (pageContent) {
            case PageContent.CLAIM_INVITE:
              return ClaimInviteScreen();
            case PageContent.DISPLAY_NAME:
              return DisplayName();
            case PageContent.USERNAME:
              // TODO(Farzad): return CreateUsername widget
              return Container();
            case PageContent.PHONE_NUMBER:
              // TODO(Farzad): return AddPhoneNumber widget
              return Container();
          }
        },
      ),
    );
  }
}
