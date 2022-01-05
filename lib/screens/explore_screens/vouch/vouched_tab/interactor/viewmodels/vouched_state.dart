part of 'vouched_bloc.dart';

class VouchedState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final List<MemberModel> vouched;
  final bool canVouch;

  const VouchedState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.vouched,
    required this.canVouch,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        vouched,
        canVouch,
      ];

  VouchedState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    List<MemberModel>? vouched,
    bool? canVouch,
  }) {
    return VouchedState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      vouched: vouched ?? this.vouched,
      canVouch: canVouch ?? this.canVouch,
    );
  }

  factory VouchedState.initial(bool isVisitor) {
    return VouchedState(
      pageState: PageState.initial,
      vouched: [],
      canVouch: !isVisitor,
    );
  }
}
