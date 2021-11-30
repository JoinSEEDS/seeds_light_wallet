import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreState.initial()) {
    on<OnExploreCardTapped>((event, emit) => emit(state.copyWith(pageCommand: NavigateToRoute(event.route))));
    on<ClearExplorePageCommand>((_, emit) => emit(state.copyWith()));
  }
}
