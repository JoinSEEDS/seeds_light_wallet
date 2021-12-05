part of 'send_scanner_bloc.dart';

class SendScannerState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;

  const SendScannerState({required this.pageState, this.pageCommand, this.errorMessage});

  @override
  List<Object?> get props => [pageState, pageCommand, errorMessage];

  SendScannerState copyWith({PageState? pageState, PageCommand? pageCommand, String? errorMessage}) {
    return SendScannerState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      pageCommand: pageCommand,
    );
  }

  factory SendScannerState.initial() {
    return const SendScannerState(pageState: PageState.initial);
  }
}
