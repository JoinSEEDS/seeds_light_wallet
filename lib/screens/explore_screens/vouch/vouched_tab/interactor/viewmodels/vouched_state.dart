part of 'vouched_bloc.dart';

class VouchedState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final List<MemberModel> vouched;

  const VouchedState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.vouched,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        vouched,
      ];

  VouchedState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    List<MemberModel>? vouched,
  }) {
    return VouchedState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      vouched: vouched ?? this.vouched,
    );
  }

  factory VouchedState.initial() {
    return const VouchedState(pageState: PageState.initial, vouched: []);
  }
}
