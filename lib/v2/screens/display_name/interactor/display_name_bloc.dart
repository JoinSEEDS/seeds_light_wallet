import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/display_name/interactor/viewmodels/display_name_events.dart';
import 'package:seeds/v2/screens/display_name/interactor/viewmodels/display_name_state.dart';

/// --- BLOC
class DisplayNameBloc extends Bloc<DisplayNameEvent, DisplayNameState> {
  DisplayNameBloc() : super(DisplayNameState.initial());

  @override
  Stream<DisplayNameState> mapEventToState(DisplayNameEvent event) async* {}
}
