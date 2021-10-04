import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegateState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool activeDelegate;

  const DelegateState({
    required this.pageState,
    this.errorMessage,
    required this.activeDelegate,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        activeDelegate,
      ];

  DelegateState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? activeDelegate,
  }) {
    return DelegateState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      activeDelegate: activeDelegate ?? this.activeDelegate,
    );
  }

  factory DelegateState.initial() {
    return const DelegateState(pageState: PageState.initial, activeDelegate: false);
  }
}
