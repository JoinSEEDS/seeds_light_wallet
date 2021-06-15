import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountFoundState extends Equatable {
  final PageState pageState;

  const RecoverAccountFoundState({
    required this.pageState,
  });

  @override
  List<Object?> get props => [pageState];

  RecoverAccountFoundState copyWith({
    PageState? pageState,
  }) {
    return RecoverAccountFoundState(
      pageState: pageState ?? this.pageState,
    );
  }

  factory RecoverAccountFoundState.initial() {
    return const RecoverAccountFoundState(pageState: PageState.initial);
  }
}
