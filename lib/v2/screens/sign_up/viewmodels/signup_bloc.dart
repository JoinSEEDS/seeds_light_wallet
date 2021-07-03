import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/create_username_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/display_name_state.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required ClaimInviteUseCase claimInviteUseCase,
  })  : _claimInviteUseCase = claimInviteUseCase,
        super(SignupState.initial());

  final ClaimInviteUseCase _claimInviteUseCase;

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is OnInviteCodeChanged) {
      yield* _claimInviteUseCase.validateInviteCode(state, event.inviteCode);
    }

    if (event is OnQRScanned) {
      yield* _claimInviteUseCase.unpackLink(state, event.scannedLink);
    }

    if (event is ClaimInviteOnNextTapped) {
      yield _claimInviteUseCase.navigateToDisplayName(state);
    }

    if (event is DisplayNameOnNextTapped) {
      yield state.copyWith(
        pageContent: PageContent.USERNAME,
        displayNameState: state.displayNameState.copyWith(displayName: event.displayName),
      );
    }

    if (event is OnUsernameChanged) {
      // TODO(Farzad): Implement call to usecase
    }

    if (event is OnBackPressed) {
      switch (state.pageContent) {
        case PageContent.CLAIM_INVITE:
          yield state;
          break;
        case PageContent.DISPLAY_NAME:
          yield state.copyWith(pageContent: PageContent.CLAIM_INVITE);
          break;
        case PageContent.USERNAME:
          yield state.copyWith(pageContent: PageContent.DISPLAY_NAME);
          break;
        case PageContent.PHONE_NUMBER:
          yield state.copyWith(pageContent: PageContent.USERNAME);
          break;
      }
    }
  }
}
