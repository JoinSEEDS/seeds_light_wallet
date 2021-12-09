part of 'vouch_bloc.dart';

class VouchState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final List<MemberModel> vouchFor;

  const VouchState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.vouchFor,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        vouchFor,
      ];

  VouchState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    List<MemberModel>? vouchFor,
  }) {
    return VouchState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      vouchFor: vouchFor ?? this.vouchFor,
    );
  }

  factory VouchState.initial() {
    return const VouchState(pageState: PageState.initial, vouchFor: []);
  }
}
