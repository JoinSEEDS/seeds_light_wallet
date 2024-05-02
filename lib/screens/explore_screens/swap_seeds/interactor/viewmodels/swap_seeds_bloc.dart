import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_signing_request_use_case.dart';
import 'package:seeds/screens/explore_screens/swap_seeds/interactor/mappers/signing_result_state_mapper.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'swap_seeds_event.dart';
part 'swap_seeds_state.dart';

class SwapSeedsBloc extends Bloc<SwapSeedsEvent, SwapSeedsState> {
  SwapSeedsBloc() : super(SwapSeedsState.initial()) {
    on<OnPageLoaded>((_, emit) => emit(state.copyWith(pageState: PageState.success)));
    on<OnMessageReceived>(_onMessageReceived);
  }

  Future<void> _onMessageReceived(OnMessageReceived event, Emitter<SwapSeedsState> emit) async {
    final result = await GetSigningRequestUseCase().run(event.javascriptMessage.message as String);
    emit(SigningResultStateMapper().mapResultToState(state, result));
  }
}
