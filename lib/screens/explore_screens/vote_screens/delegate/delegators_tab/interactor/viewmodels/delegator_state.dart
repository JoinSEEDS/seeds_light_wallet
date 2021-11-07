import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegatorState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<MemberModel>? delegators;

  const DelegatorState({
    required this.pageState,
    this.errorMessage,
    this.delegators,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        delegators,
      ];

  DelegatorState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<MemberModel>? delegators,
  }) {
    return DelegatorState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      delegators: delegators ?? this.delegators,
    );
  }

  factory DelegatorState.initial() {
    return const DelegatorState(
      pageState: PageState.initial,
    );
  }
}
