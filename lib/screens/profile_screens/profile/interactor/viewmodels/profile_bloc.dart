import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/domain-shared/shared_use_cases/guardian_notification_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/mappers/profile_values_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/mappers/update_profile_image_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/mappers/upgrade_citizenship_result_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/get_profile_values_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/make_citizen_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/make_resident_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/save_image_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/usecases/update_profile_image_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';
import 'package:share/share.dart';

/// --- BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late StreamSubscription<bool> _hasGuardianNotificationPending;

  ProfileBloc() : super(ProfileState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value)));
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileValues) {
      yield state.copyWith(pageState: PageState.loading);
      final results = await GetProfileValuesUseCase().run();
      yield ProfileValuesStateMapper().mapResultToState(state, results);
    }
    if (event is OnUpdateProfileImage) {
      yield state.copyWith(pageState: PageState.loading);
      final urlResult = await SaveImageUseCase().run(file: event.file);
      final result = await UpdateProfileImageUseCase().run(imageUrl: urlResult.asValue!.value, profile: state.profile!);
      yield UpdateProfileImageStateMapper().mapResultToState(state, result);
    }
    if (event is OnNameChanged) {
      yield state.copyWith(profile: state.profile!.copyWith(nickname: event.name));
    }
    if (event is OnCurrencyChanged) {
      // Change the state to trigger repaint
      yield state.copyWith(pageState: PageState.loading);
      yield state.copyWith(pageState: PageState.success);
      eventBus.fire(const OnFiatCurrencyChangedEventBus());
    }
    if (event is OnProfileLogoutButtonPressed) {
      yield state.copyWith(pageCommand: ShowLogoutDialog());
    }
    if (event is OnSavePrivateKeyButtonPressed) {
      yield state.copyWith(showLogoutButton: true);
      await Share.share(settingsStorage.privateKey!);
      settingsStorage.savePrivateKeyBackedUp(true);
    }
    if (event is ClearShowLogoutDialog) {
      yield state.copyWith();
    }
    if (event is ResetShowLogoutButton) {
      yield state.copyWith(showLogoutButton: false);
    }
    if (event is ShouldShowNotificationBadge) {
      yield state.copyWith(hasSecurityNotification: event.value);
    }
    if (event is OnActivateResidentButtonTapped) {
      yield state.copyWith(pageCommand: ShowProcessingCitizenshipUpgrade());
      final Result result = await MakeResidentUseCase().run();
      yield UpgradeCitizenshipResultMapper().mapResultToState(state, result, false);
    }
    if (event is OnActivateCitizenButtonTapped) {
      yield state.copyWith(pageCommand: ShowProcessingCitizenshipUpgrade());
      final Result result = await MakeCitizenUseCase().run();
      yield UpgradeCitizenshipResultMapper().mapResultToState(state, result, true);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    return super.close();
  }
}
