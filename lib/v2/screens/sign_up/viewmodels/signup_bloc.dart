import 'dart:async';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/screens/sign_up/add_phone_number/mappers/create_account_mapper.dart';
import 'package:seeds/v2/screens/sign_up/add_phone_number/usecases/add_phone_number_usecase.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/mappers/claim_invite_mapper.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/usecases/claim_invite_usecase.dart';
import 'package:seeds/v2/screens/sign_up/create_username/usecases/create_username_usecase.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/add_phone_number_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/create_username_state.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/display_name_state.dart';
import 'package:seeds/v2/utils/mnemonic_code/mnemonic_code.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final DeeplinkBloc deeplinkBloc;
  final ClaimInviteUseCase _claimInviteUseCase;
  final CreateUsernameUseCase _createUsernameUseCase;
  final AddPhoneNumberUseCase _addPhoneNumberUseCase;

  SignupBloc({
    required ClaimInviteUseCase claimInviteUseCase,
    required CreateUsernameUseCase createUsernameUseCase,
    required AddPhoneNumberUseCase addPhoneNumberUseCase,
    required this.deeplinkBloc,
  })  : _claimInviteUseCase = claimInviteUseCase,
        _createUsernameUseCase = createUsernameUseCase,
        _addPhoneNumberUseCase = addPhoneNumberUseCase,
        super(SignupState.initial());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    // if it has a invite deep link
    if (event is OnInviteCodeFromDeepLink) {
      if (event.inviteCode != null) {
        yield state.copyWith(
          claimInviteState: state.claimInviteState.copyWith(
            inviteMnemonic: event.inviteCode,
            claimInviteView: ClaimInviteView.processing,
            pageCommand: StopScan(),
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Result result = await _claimInviteUseCase.validateInviteCode(event.inviteCode!);
        yield ClaimInviteMapper().mapValidateInviteCodeToState(state, result);
        // if success shows successs screen for 1 second then move to add name
        if (state.claimInviteState.claimInviteView == ClaimInviteView.success) {
          await Future.delayed(const Duration(seconds: 1));
          yield state.copyWith(
            claimInviteState:
                state.claimInviteState.copyWith(claimInviteView: ClaimInviteView.scanner, pageCommand: StartScan()),
            signupScreens: SignupScreens.displayName,
          );
        }
      } else {
        // No link set the scanner view and start it
        yield state.copyWith(
          claimInviteState: state.claimInviteState.copyWith(
            claimInviteView: ClaimInviteView.scanner,
            pageCommand: StartScan(),
          ),
        );
      }
    }

    if (event is OnQRScanned) {
      yield state.copyWith(
        claimInviteState: state.claimInviteState.copyWith(
          claimInviteView: ClaimInviteView.processing,
          pageCommand: StopScan(),
        ),
      );
      Result result = await _claimInviteUseCase.unpackLink(event.scannedLink);
      yield ClaimInviteMapper().mapInviteMnemonicToState(state, result);
      // if success shows successs screen for 1 second then move to add name
      if (state.claimInviteState.claimInviteView == ClaimInviteView.success) {
        await Future.delayed(const Duration(seconds: 1));
        yield state.copyWith(
            claimInviteState:
                state.claimInviteState.copyWith(claimInviteView: ClaimInviteView.scanner, pageCommand: StartScan()),
            signupScreens: SignupScreens.displayName);
      }
    }

    if (event is ClearClaimInvitePageCommand) {
      yield state.copyWith(claimInviteState: state.claimInviteState.copyWith(pageCommand: null));
    }

    if (event is OnInvalidInviteDialogClosed) {
      yield state.copyWith(
        claimInviteState: state.claimInviteState.copyWith(
          claimInviteView: ClaimInviteView.scanner,
          pageCommand: StartScan(),
        ),
      );
    }

    if (event is DisplayNameOnNextTapped) {
      yield state.copyWith(
        signupScreens: SignupScreens.username,
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
      yield state.copyWith(signupScreens: SignupScreens.phoneNumber);
    }

    if (event is OnCreateAccountTapped) {
      yield* createAccount(state, event.phoneNumber);
    }

    if (event is OnBackPressed) {
      switch (state.signupScreens) {
        case SignupScreens.claimInvite:
          yield state;
          break;
        case SignupScreens.displayName:
          yield state.copyWith(signupScreens: SignupScreens.claimInvite);
          break;
        case SignupScreens.username:
          yield state.copyWith(signupScreens: SignupScreens.displayName);
          break;
        case SignupScreens.phoneNumber:
          yield state.copyWith(signupScreens: SignupScreens.username);
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

    EOSPrivateKey privateKey = EOSPrivateKey.fromRandom();

    final Result result = await _addPhoneNumberUseCase.run(
      inviteSecret: inviteSecret,
      displayName: displayName!,
      username: username!,
      privateKey: privateKey,
      phoneNumber: phoneNumber,
    );

    if (!result.isError) {
      settingsStorage.saveAccount(username, privateKey.toString());
    }

    yield CreateAccountMapper().mapOnCreateAccountTappedToState(currentState, result);
  }
}
