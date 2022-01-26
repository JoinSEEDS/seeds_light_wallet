part of 'delegators_bloc.dart';

class DelegatorsState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<ProfileModel> delegators;

  const DelegatorsState({
    required this.pageState,
    this.errorMessage,
    required this.delegators,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        delegators,
      ];

  DelegatorsState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? delegators,
  }) {
    return DelegatorsState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      delegators: delegators ?? this.delegators,
    );
  }

  factory DelegatorsState.initial() {
    return const DelegatorsState(pageState: PageState.initial, delegators: []);
  }
}
