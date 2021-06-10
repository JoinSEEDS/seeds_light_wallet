import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountState extends Equatable {
  final PageState pageState;

  const RecoverAccountState({
    required this.pageState,
  });

  @override
  List<Object> get props => [pageState];

  RecoverAccountState copyWith({
    PageState? pageState,
  }) {
    return RecoverAccountState(
      pageState: pageState ?? this.pageState,
    );
  }

  factory RecoverAccountState.initial() {
    return const RecoverAccountState(pageState: PageState.initial);
  }
}
