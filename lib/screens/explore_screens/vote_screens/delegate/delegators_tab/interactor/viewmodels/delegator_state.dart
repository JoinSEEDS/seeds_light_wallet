import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegatorState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<MemberModel>? delegators;
  final bool hasDelegators;

  const DelegatorState({
    required this.pageState,
    this.errorMessage,
    this.delegators,
    required this.hasDelegators,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        delegators,
        hasDelegators,
      ];

  DelegatorState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<MemberModel>? delegators,
    bool? hasDelegators,
  }) {
    return DelegatorState(
        pageState: pageState ?? this.pageState,
        errorMessage: errorMessage,
        delegators: delegators ?? this.delegators,
        hasDelegators: hasDelegators ?? this.hasDelegators);
  }

  factory DelegatorState.initial() {
    return const DelegatorState(
      pageState: PageState.initial,
      hasDelegators: false,
    );
  }
}
