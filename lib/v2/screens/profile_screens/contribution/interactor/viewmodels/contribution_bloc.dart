import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/bloc.dart';

/// --- BLOC
class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
  ContributionBloc() : super(ContributionState.initial());

  @override
  Stream<ContributionState> mapEventToState(ContributionEvent event) async* {
    if (event is SetScores) {
      if (event.score == null) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
      } else {
        yield state.copyWith(pageState: PageState.success, score: event.score);
      }
    }
  }
}
