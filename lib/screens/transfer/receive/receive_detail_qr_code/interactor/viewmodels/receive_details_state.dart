part of 'receive_details_bloc.dart';

class ReceiveDetailsState extends Equatable {
  final ReceiveDetails details;
  final ReceivePaidSuccessArgs? receivePaidSuccessArgs;
  final bool isCheckButtonLoading;

  const ReceiveDetailsState({
    required this.details,
    this.receivePaidSuccessArgs,
    required this.isCheckButtonLoading,
  });

  @override
  List<Object?> get props => [
        receivePaidSuccessArgs,
        isCheckButtonLoading,
      ];

  ReceiveDetailsState copyWith({ReceivePaidSuccessArgs? receivePaidSuccessArgs, bool? isCheckButtonLoading}) {
    return ReceiveDetailsState(
      details: details,
      receivePaidSuccessArgs: receivePaidSuccessArgs,
      isCheckButtonLoading: isCheckButtonLoading ?? this.isCheckButtonLoading,
    );
  }

  factory ReceiveDetailsState.initial(ReceiveDetails details) {
    return ReceiveDetailsState(details: details, isCheckButtonLoading: false);
  }
}
