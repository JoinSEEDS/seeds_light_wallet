import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/repositories/remote/profile_repository.dart';
import 'package:seeds/v2/screens/profile/interactor/events.dart';
import 'package:seeds/v2/screens/profile/interactor/mappers/profile_state_mapper.dart';
import 'package:seeds/v2/screens/profile/interactor/profile_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

/// --- BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      yield state.copyWith(pageState: PageState.initial);

      Result result = await GetProfileUseCase(profileRepository: _profileRepository).run("raul11111111");
      yield ProfileStateMapper().mapToState(state, result);
    }
  }
}
