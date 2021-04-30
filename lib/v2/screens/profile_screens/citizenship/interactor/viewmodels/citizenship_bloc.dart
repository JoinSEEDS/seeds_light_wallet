import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/bloc.dart';

/// --- BLOC
class CitizenshipBloc extends Bloc<CitizenshipEvent, CitizenshipState> {
  CitizenshipBloc() : super(CitizenshipState.initial());

  @override
  Stream<CitizenshipState> mapEventToState(CitizenshipEvent event) async* {
    if (event is SetValues) {
      if (event.profile == null || event.score == null) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
      } else {
        yield state.copyWith(
          pageState: PageState.success,
          profile: event.profile,
          score: event.score,
          progressTimeline: 0,
          invitedResidents: 0,
          invitedVisitors: 0,
        );
      }
    }
  }
}
