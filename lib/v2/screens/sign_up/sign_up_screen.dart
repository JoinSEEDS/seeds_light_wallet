import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/signup/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/signup_bloc.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite_screen.dart';

class SignUpFlowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignupBloc(
        claimInviteUseCase: ClaimInviteUseCase(
          signupRepository: SignupRepository(),
        ),
      ),
      child: SignUpScreen(),
    );
  }
}
