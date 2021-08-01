import 'dart:async';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/sign_up/add_phone_number/mappers/create_account_mapper.dart';
import 'package:seeds/v2/screens/sign_up/add_phone_number/usecases/add_phone_number_usecase.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/screens/sign_up/create_username/usecases/create_username_usecase.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/add_phone_number_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/create_username_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/display_name_state.dart';
import 'package:seeds/v2/utils/mnemonic_code/mnemonic_code.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final DeeplinkBloc deeplinkBloc;

  SignupBloc({
    required ClaimInviteUseCase claimInviteUseCase,
    required CreateUsernameUseCase createUsernameUseCase,
    required AddPhoneNumberUseCase addPhoneNumberUseCase,
    required this.deeplinkBloc,
  })  : _claimInviteUseCase = claimInviteUseCase,
        _createUsernameUseCase = createUsernameUseCase,
        _addPhoneNumberUseCase = addPhoneNumberUseCase,
        super(SignupState.initial());

  final ClaimInviteUseCase _claimInviteUseCase;
  final CreateUsernameUseCase _createUsernameUseCase;
  final AddPhoneNumberUseCase _addPhoneNumberUseCase;

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is OnInviteCodeChanged) {
      yield* _claimInviteUseCase.validateInviteCode(state, event.inviteCode);
    }

    if (event is OnInviteCodeFromDeepLink) {
      if (event.inviteCode != null) {
        yield state.copyWith(
            claimInviteState: state.claimInviteState.copyWith(
          inviteMnemonic: event.inviteCode,
          pageState: PageState.success,
          pageCommand: StopScan(),
        ));

        yield* _claimInviteUseCase.validateInviteCode(state, event.inviteCode!);
      }
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

    if (event is OnGenerateNewUsername) {
      yield* _createUsernameUseCase.generateNewUsername(state, event.fullname);
    }

    if (event is OnUsernameChanged) {
      yield* _createUsernameUseCase.validateUsername(state, event.username);
    }

    if (event is CreateUsernameOnNextTapped) {
      yield state.copyWith(
        pageContent: PageContent.PHONE_NUMBER,
      );
    }

    if (event is OnCreateAccountTapped) {
      yield* createAccount(state, event.phoneNumber);
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

  Stream<SignupState> createAccount(SignupState currentState, String? phoneNumber) async* {
    final currentAddPhoneNumberState = currentState.addPhoneNumberState;

    yield currentState.copyWith(addPhoneNumberState: AddPhoneNumberState.loading(currentAddPhoneNumberState));

    final String inviteSecret = secretFromMnemonic(state.claimInviteState.inviteMnemonic!);
    final displayName = state.displayNameState.displayName;
    final username = state.createUsernameState.username;

    final Result result = await _addPhoneNumberUseCase.run(
        inviteSecret: inviteSecret, displayName: displayName!, username: username!, phoneNumber: phoneNumber);

    yield CreateAccountMapper().mapOnCreateAccountTappedToState(currentState, result);
  }
}
