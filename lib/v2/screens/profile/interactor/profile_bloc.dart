import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/screens/profile/interactor/mappers/profile_state_mapper.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';
import 'package:seeds/v2/screens/profile/interactor/viewmodels/events.dart';
import 'package:seeds/v2/screens/profile/interactor/viewmodels/profile_state.dart';

/// --- BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      yield state.copyWith(pageState: PageState.initial);

      Result result = await GetProfileUseCase().run(event.userName);
      yield ProfileStateMapper().mapResultToState(state, result);
    }
  }
}
