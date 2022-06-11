import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/domain-shared/shared_use_cases/load_sponsors_use_case.dart';
import 'package:seeds/screens/explore_screens/vouch/sponsor_tab/interactor/mappers/load_sponsors_state_mapper.dart';

part 'sponsor_event.dart';
part 'sponsor_state.dart';

class SponsorBloc extends Bloc<SponsorEvent, SponsorState> {
  SponsorBloc() : super(SponsorState.initial()) {
    on<LoadUserSponsorList>(_loadUserSponsorList);
  }

  Future<void> _loadUserSponsorList(LoadUserSponsorList event, Emitter<SponsorState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<List<ProfileModel>> results = await LoadSponsorsUseCase().run();
    emit(LoadSponsorsStateMapper().mapResultToState(state, results));
  }
}
