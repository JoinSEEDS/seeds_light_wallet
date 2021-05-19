import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required ClaimInviteUseCase claimInviteUseCase,
  })   : _claimInviteUseCase = claimInviteUseCase,
        super(SignupState.initial());

  final ClaimInviteUseCase _claimInviteUseCase;

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is ValidateInviteCode) {
      yield* _claimInviteUseCase.validateInviteCode(state, event.inviteCode);
    }

    if (event is UnpackScannedLink) {
      yield* _claimInviteUseCase.unpackLink(state, event.scannedLink);
    }
  }
}
