import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_event.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_state.dart';

/// --- BLOC
class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  DeeplinkBloc() : super(DeeplinkState.initial());

  @override
  Stream<DeeplinkState> mapEventToState(DeeplinkEvent event) async* {}
}
