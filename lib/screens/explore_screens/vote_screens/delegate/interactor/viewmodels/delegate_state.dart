import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegateState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool activeDelegate;
  final DelegateModel? delegate;

  const DelegateState({
    required this.pageState,
    this.errorMessage,
    required this.activeDelegate,
    this.delegate,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        activeDelegate,
        delegate,
      ];

  DelegateState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? activeDelegate,
    DelegateModel? delegate,
  }) {
    return DelegateState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      activeDelegate: activeDelegate ?? this.activeDelegate,
      delegate: delegate ?? this.delegate,
    );
  }

  factory DelegateState.initial() {
    return const DelegateState(pageState: PageState.initial, activeDelegate: false);
  }
}
