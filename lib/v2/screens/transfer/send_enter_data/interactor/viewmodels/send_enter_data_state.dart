import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendEnterDataPageState extends Equatable {
  final PageState pageState;
  final String? error;

  const SendEnterDataPageState({required this.pageState, this.error});

  @override
  List<Object> get props => [pageState];

  SendEnterDataPageState copyWith({PageState? pageState, String? error}) {
    return SendEnterDataPageState(pageState: pageState ?? this.pageState, error: error ?? this.error);
  }

  factory SendEnterDataPageState.initial() {
    return const SendEnterDataPageState(pageState: PageState.initial);
  }
}
