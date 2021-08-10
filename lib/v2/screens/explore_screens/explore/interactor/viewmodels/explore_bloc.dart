import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/screens/explore_screens/explore/interactor/viewmodels/bloc.dart';

/// --- BLOC
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreState.initial());

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if (event is OnExploreCardTapped) {
      yield state.copyWith(pageCommand: NavigateToRoute(event.route));
    }
    if (event is ClearExplorePageCommand) {
      yield state.copyWith();
    }
  }
}
