import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_signing_request_use_case.dart';
import 'package:seeds/screens/explore_screens/p2p/interactor/mappers/signing_result_state_mapper.dart';
import 'package:webview_flutter/platform_interface.dart';

part 'p2p_event.dart';
part 'p2p_state.dart';

class P2PBloc extends Bloc<P2PEvent, P2PState> {
  P2PBloc() : super(P2PState.initial()) {
    on<OnPageLoaded>((_, emit) => emit(state.copyWith(pageState: PageState.success)));
    on<OnMessageReceived>(_onMessageReceived);
  }

  Future<void> _onMessageReceived(OnMessageReceived event, Emitter<P2PState> emit) async {
    final result = await GetSigningRequestUseCase().run(event.javascriptMessage.message);
    emit(SigningResultStateMapper().mapResultToState(state, result));
  }
}
