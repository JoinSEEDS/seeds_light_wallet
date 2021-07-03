import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/mappers/profile_values_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/mappers/update_profile_image_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/usecases/get_profile_values_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/usecases/save_image_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/usecases/update_profile_image_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';
import 'package:share/share.dart';

/// --- BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileValues) {
      yield state.copyWith(pageState: PageState.loading);
      var results = await GetProfileValuesUseCase().run();
      yield ProfileValuesStateMapper().mapResultToState(state, results);
    }
    if (event is OnUpdateProfileImage) {
      yield state.copyWith(pageState: PageState.loading);
      var urlResult = await SaveImageUseCase().run(file: event.file);
      var result = await UpdateProfileImageUseCase().run(imageUrl: urlResult.asValue!.value, profile: state.profile!);
      yield UpdateProfileImageStateMapper().mapResultToState(state, result);
    }
    if (event is OnNameChanged) {
      yield state.copyWith(profile: state.profile!.copyWith(nickname: event.name));
    }
    if (event is OnCurrencyChanged) {
      // Change the state to trigger repaint
      yield state.copyWith(pageState: PageState.loading);
      yield state.copyWith(pageState: PageState.success);
    }
    if (event is OnProfileLogoutButtonPressed) {
      yield state.copyWith(showDialog: ShowLogoutDialog());
    }
    if (event is OnSavePrivateKeyButtonPressed) {
      yield state.copyWith(showLogoutButton: true);
      await Share.share(settingsStorage.privateKey!);
      settingsStorage.savePrivateKeyBackedUp(true);
    }
    if (event is ClearShowLogoutDialog) {
      yield state.copyWith(showDialog: null);
    }
    if (event is ResetShowLogoutButton) {
      yield state.copyWith(showLogoutButton: false);
    }
  }
}
