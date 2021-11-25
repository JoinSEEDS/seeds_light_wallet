import 'dart:async';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/generate_random_key_and_words_use_case.dart';
import 'package:seeds/screens/authentication/sign_up2/mappers/claim_invite_mapper.dart';
import 'package:seeds/screens/authentication/sign_up2/mappers/create_account_state_mapper.dart';
import 'package:seeds/screens/authentication/sign_up2/mappers/set_account_name_state_mapper.dart';
import 'package:seeds/screens/authentication/sign_up2/usecases/check_account_name_availability_usecase.dart';
import 'package:seeds/screens/authentication/sign_up2/usecases/claim_invite_usecase.dart';
import 'package:seeds/screens/authentication/sign_up2/usecases/create_account_usecase.dart';
import 'package:seeds/screens/authentication/sign_up2/viewmodels/page_commands.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';
import 'package:seeds/utils/string_extension.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState.initial()) {
    on<OnInviteCodeFromDeepLink>(_onInviteCodeFromDeepLink);
    on<OnQRScanned>(_onQRScanned);
    on<OnInvalidInviteDialogClosed>(_onInvalidInviteDialogClosed);
    on<DisplayNameOnNextTapped>(_displayNameOnNextTapped);
    on<OnGenerateNewUsername>(_onGenerateNewUsername);
    on<OnAccountNameChanged>(_onAccountNameChanged);
    on<OnCreateAccountTapped>(_onCreateAccountTapped);
    on<OnBackPressed>(_onBackPressed);
    on<ClearSignupPageCommand>((_, emit) => emit(state.copyWith()));
  }

  // if it has a invite deep link
  Future<void> _onInviteCodeFromDeepLink(OnInviteCodeFromDeepLink event, Emitter<SignupState> emit) async {
    if (event.inviteCode != null) {
      emit(state.copyWith(
        inviteMnemonic: event.inviteCode,
        claimInviteView: ClaimInviteView.processing,
        pageCommand: StopScan(),
        fromDeepLink: true,
      ));
      await Future.delayed(const Duration(seconds: 1));
      final Result result = await ClaimInviteUseCase().validateInviteCode(event.inviteCode!);
      emit(ClaimInviteMapper().mapValidateInviteCodeToState(state, result));
      // if success shows successs screen for 1 second then move to add name
      if (state.claimInviteView == ClaimInviteView.success) {
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(
          claimInviteView: ClaimInviteView.scanner,
          pageCommand: StartScan(),
          signupScreens: SignupScreens.displayName,
        ));
      }
    } else {
      // No link set the scanner view and start it
      emit(state.copyWith(claimInviteView: ClaimInviteView.scanner, pageCommand: StartScan()));
    }
  }

  Future<void> _onQRScanned(OnQRScanned event, Emitter<SignupState> emit) async {
    emit(state.copyWith(claimInviteView: ClaimInviteView.processing, pageCommand: StopScan(), fromDeepLink: false));
    final Result result = await ClaimInviteUseCase().unpackLink(event.scannedLink);
    await Future.delayed(const Duration(seconds: 1));
    emit(ClaimInviteMapper().mapInviteMnemonicToState(state, result));

    if (state.inviteMnemonic != null) {
      emit(state.copyWith(pageCommand: StopScan()));
      final Result result = await ClaimInviteUseCase().validateInviteCode(state.inviteMnemonic!);
      emit(ClaimInviteMapper().mapValidateInviteCodeToState(state, result));
    }

    // if success shows successs screen for 1 second then move to add name
    if (state.claimInviteView == ClaimInviteView.success) {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        claimInviteView: ClaimInviteView.scanner,
        pageCommand: StartScan(),
        signupScreens: SignupScreens.displayName,
      ));
    }
  }

  void _onInvalidInviteDialogClosed(OnInvalidInviteDialogClosed event, Emitter<SignupState> emit) {
    emit(state.copyWith(claimInviteView: ClaimInviteView.scanner, pageCommand: StartScan()));
  }

  void _displayNameOnNextTapped(DisplayNameOnNextTapped event, Emitter<SignupState> emit) {
    emit(state.copyWith(signupScreens: SignupScreens.accountName, displayName: event.displayName));
  }

  void _onGenerateNewUsername(OnGenerateNewUsername event, Emitter<SignupState> emit) {
    emit(state.copyWith(pageCommand: OnAccountNameGenerated(), accountName: _generateUseName(event.fullname)));
  }

  Future<void> _onAccountNameChanged(OnAccountNameChanged event, Emitter<SignupState> emit) async {
    final validationError = _validateUsername(event.accountName);
    if (validationError == null) {
      emit(state.copyWith(pageState: PageState.loading));
      final Result result = await CheckAccountNameAvailabilityUseCase().run(event.accountName);
      emit(SetAccountNameStateMapper().mapResultToState(state, event.accountName, result));
    } else {
      emit(state.copyWith(pageState: PageState.failure, errorMessage: validationError));
    }
  }

  Future<void> _onCreateAccountTapped(OnCreateAccountTapped event, Emitter<SignupState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final String inviteSecret = secretFromMnemonic(state.inviteMnemonic!);
    final AuthDataModel authData = GenerateRandomKeyAndWordsUseCase().run();
    final Result result = await CreateAccountUseCase().run(
      inviteSecret: inviteSecret,
      displayName: state.displayName!,
      accountName: state.accountName!,
      authData: authData,
      phoneNumber: '',
    );
    emit(CreateAccountStateMapper().mapResultToState(state, result, authData));
  }

  void _onBackPressed(OnBackPressed event, Emitter<SignupState> emit) {
    switch (state.signupScreens) {
      case SignupScreens.claimInvite:
        emit(state);
        break;
      case SignupScreens.displayName:
        if (state.fromDeepLink) {
          // Not return to processing screen if it is from invite link
          emit(state.copyWith(pageCommand: ReturnToLogin()));
        } else {
          emit(state.copyWith(signupScreens: SignupScreens.claimInvite));
        }
        break;
      case SignupScreens.accountName:
        emit(state.copyWith(signupScreens: SignupScreens.displayName));
        break;
    }
  }
}

String? _validateUsername(String? username) {
  final validCharacters = RegExp(r'^[a-z1-5]+$');

  if (username.isNullOrEmpty) {
    return 'Please select a username';
    // ignore: unnecessary_raw_strings
  } else if (RegExp(r'0|6|7|8|9').allMatches(username!).isNotEmpty) {
    return 'Only numbers 1-5 can be used.';
  } else if (username.toLowerCase() != username) {
    return "Name can be lowercase only";
  } else if (!validCharacters.hasMatch(username) || username.contains(' ')) {
    return "No special characters or spaces can be used";
  } else if (username.length != 12) {
    return 'Username must be 12 characters long';
  }

  return null;
}

String _generateUseName(String fullname) {
  String suggestedUsername = fullname.toLowerCase().trim().split('').map((character) {
    // ignore: unnecessary_raw_strings
    final legalChar = RegExp(r'[a-z]|1|2|3|4|5').allMatches(character).isNotEmpty;

    return legalChar ? character : '';
  }).join();

  suggestedUsername = suggestedUsername.padRight(12, '1');

  return suggestedUsername.substring(0, 12);
}
