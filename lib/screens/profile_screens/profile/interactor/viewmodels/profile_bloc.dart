import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/score_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_words_from_private_key_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/guardian_notification_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/save_image_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/should_show_recovery_phrase_features_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/mappers/profile_values_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/mappers/update_profile_image_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/mappers/upgrade_citizenship_result_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/get_profile_values_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/make_citizen_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/make_resident_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/update_profile_image_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:share_plus/share_plus.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late StreamSubscription<bool> _hasGuardianNotificationPending;

  ProfileBloc(bool isImportAccountEnabled) : super(ProfileState.initial(isImportAccountEnabled)) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value)));
    on<LoadProfileValues>(_loadProfileValues);
    on<OnUpdateProfileImage>(_onUpdateProfileImage);
    on<OnNameChanged>((event, emit) => emit(state.copyWith(profile: state.profile!.copyWith(nickname: event.name))));
    on<OnCurrencyChanged>(_onCurrencyChanged);
    on<OnProfileLogoutButtonPressed>(_onProfileLogoutButtonPressed);
    on<OnSavePrivateKeyButtonPressed>(_onSavePrivateKeyButtonPressed);
    on<OnSaveRecoveryPhraseButtonPressed>(_onSaveRecoveryPhraseButtonPressed);
    on<OnActivateResidentButtonTapped>(_onActivateResidentButtonTapped);
    on<OnActivateCitizenButtonTapped>(_onActivateCitizenButtonTapped);
    on<ResetShowLogoutButton>((_, emit) => emit(state.copyWith(showLogoutButton: false)));
    on<OnSwitchAccountButtonTapped>((_, emit) => emit(state.copyWith(pageCommand: ShowSwitchAccount())));
    on<ShouldShowNotificationBadge>((event, emit) => emit(state.copyWith(hasSecurityNotification: event.value)));
    on<ClearProfilePageCommand>((_, emit) => emit(state.copyWith()));
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    return super.close();
  }

  Future<void> _loadProfileValues(LoadProfileValues event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<GetProfileValuesResponse> result = await GetProfileValuesUseCase().run();
    emit(ProfileValuesStateMapper().mapResultToState(state, result));
  }

  Future<void> _onUpdateProfileImage(OnUpdateProfileImage event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final urlResult = await SaveImageUseCase().run(SaveImageUseCaseInput(
        file: event.file, pathPrefix: PathPrefix.profileImage, creatorId: settingsStorage.accountName));
    final result = await UpdateProfileImageUseCase()
        .run(UpdateProfileImageUseCase.input(imageUrl: urlResult.asValue!.value, profile: state.profile!));
    emit(UpdateProfileImageStateMapper().mapResultToState(state, result));
  }

  void _onCurrencyChanged(OnCurrencyChanged event, Emitter<ProfileState> emit) {
    // Change the state to trigger repaint
    emit(state.copyWith(pageState: PageState.loading));
    emit(state.copyWith(pageState: PageState.success));
    eventBus.fire(const OnFiatCurrencyChangedEventBus());
  }

  void _onProfileLogoutButtonPressed(OnProfileLogoutButtonPressed event, Emitter<ProfileState> emit) {
    if (ShouldShowRecoveryPhraseFeatureUseCase().shouldShowRecoveryPhrase()) {
      emit(state.copyWith(pageCommand: ShowLogoutRecoveryPhraseDialog()));
    } else {
      emit(state.copyWith(pageCommand: ShowLogoutDialog()));
    }
  }

  Future<void> _onSavePrivateKeyButtonPressed(OnSavePrivateKeyButtonPressed event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(showLogoutButton: true));
    await Share.share(settingsStorage.privateKey!);
    settingsStorage.savePrivateKeyBackedUp(true);
  }

  Future<void> _onSaveRecoveryPhraseButtonPressed(
      OnSaveRecoveryPhraseButtonPressed event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(showLogoutButton: true));
    final String words = GetWordsFromPrivateKey().run().join(' ');
    await Share.share(words);
    settingsStorage.savePrivateKeyBackedUp(true);
  }

  Future<void> _onActivateResidentButtonTapped(OnActivateResidentButtonTapped event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(pageCommand: ShowProcessingCitizenshipUpgrade()));
    final Result result = await MakeResidentUseCase().run();
    emit(UpgradeCitizenshipResultMapper().mapResultToState(state, result, ProfileStatus.resident));
  }

  Future<void> _onActivateCitizenButtonTapped(OnActivateCitizenButtonTapped event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(pageCommand: ShowProcessingCitizenshipUpgrade()));
    final Result result = await MakeCitizenUseCase().run();
    emit(UpgradeCitizenshipResultMapper().mapResultToState(state, result, ProfileStatus.citizen));
  }
}
