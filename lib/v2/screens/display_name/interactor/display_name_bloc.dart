import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/display_name/interactor/viewmodels/display_name_events.dart';
import 'package:seeds/v2/screens/display_name/interactor/viewmodels/display_name_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/utils/cap_utils.dart';

/// --- BLOC
class DisplayNameBloc extends Bloc<DisplayNameEvent, DisplayNameState> {
  DisplayNameBloc() : super(DisplayNameState.initial());

  @override
  Stream<DisplayNameState> mapEventToState(DisplayNameEvent event) async* {

    if (event is InitDisplayNameConfirmationWithArguments) {
      yield state.copyWith(
          pageState: PageState.success,
          invSecret: event.arguments.invSecret,
      );
    }

  }
}
