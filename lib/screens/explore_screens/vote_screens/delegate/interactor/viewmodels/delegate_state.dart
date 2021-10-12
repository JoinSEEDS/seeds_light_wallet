import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegateState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final String? errorMessage;
  final bool activeDelegate;
  final DelegateModel? delegate;

  const DelegateState({
    this.pageCommand,
    required this.pageState,
    this.errorMessage,
    required this.activeDelegate,
    this.delegate,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        errorMessage,
        activeDelegate,
        delegate,
      ];

  DelegateState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    String? errorMessage,
    bool? activeDelegate,
    DelegateModel? delegate,
  }) {
    return DelegateState(
      pageCommand: pageCommand,
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
