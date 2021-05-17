import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/claim_invite_screen.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignupBloc(
        claimInviteUseCase: ClaimInviteUseCase(
          signupRepository: SignupRepository(),
        ),
      ),
      child: ClaimInviteScreen(),
    );
  }
}
