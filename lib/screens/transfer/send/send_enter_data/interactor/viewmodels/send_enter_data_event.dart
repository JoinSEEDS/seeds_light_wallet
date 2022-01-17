part of 'send_enter_data_bloc.dart';

abstract class SendEnterDataEvent extends Equatable {
  const SendEnterDataEvent();

  @override
  List<Object?> get props => [];
}

class InitSendDataArguments extends SendEnterDataEvent {
  @override
  String toString() => 'InitSendDataArguments: { InitSendDataArguments: }';
}

class OnAmountChange extends SendEnterDataEvent {
  final String amountChanged;

  const OnAmountChange({required this.amountChanged});

  @override
  String toString() => 'OnAmountChange: { OnAmountChange: $amountChanged }';
}

class OnMemoChange extends SendEnterDataEvent {
  final String memoChanged;

  const OnMemoChange({required this.memoChanged});

  @override
  String toString() => 'OnMemoChange: { OnMemoChange: $memoChanged }';
}

class OnNextButtonTapped extends SendEnterDataEvent {
  const OnNextButtonTapped();

  @override
  String toString() => 'OnNextButtonTapped';
}

class OnSendButtonTapped extends SendEnterDataEvent {
  const OnSendButtonTapped();

  @override
  String toString() => 'OnSendButtonTapped';
}

class ClearSendEnterDataPageCommand extends SendEnterDataEvent {
  const ClearSendEnterDataPageCommand();

  @override
  String toString() => 'ClearSendEnterDataPageCommand';
}
