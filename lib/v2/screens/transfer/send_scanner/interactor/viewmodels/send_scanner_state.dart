import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendPageState extends Equatable {
  final PageState pageState;
  final String? error;
  final NavigateToCustomTransaction? pageCommand;

  const SendPageState({required this.pageState, this.error, this.pageCommand});

  @override
  List<Object> get props => [pageState];

  SendPageState copyWith({PageState? pageState, String? error, NavigateToCustomTransaction? pageCommand}) {
    return SendPageState(
        pageState: pageState ?? this.pageState,
        error: error ?? this.error,
        pageCommand: pageCommand ?? this.pageCommand);
  }

  factory SendPageState.initial() {
    return const SendPageState(pageState: PageState.initial);
  }
}

class NavigateToCustomTransaction {
  final ScanQrCodeResultData resultData;

  NavigateToCustomTransaction(this.resultData);
}
