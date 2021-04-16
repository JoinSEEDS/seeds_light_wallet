import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class DisplayNameState extends Equatable {
  final PageState? pageState;
  final String? errorMessage;
  final String? privateKey;

  const DisplayNameState({@required this.pageState, this.errorMessage, this.privateKey});

  @override
  List<Object?> get props => [pageState, errorMessage, privateKey];

  DisplayNameState copyWith({
    PageState? pageState,
    String? errorMessage,
    String? privateKey,
  }) {
    return DisplayNameState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      privateKey: privateKey ?? this.privateKey,
    );
  }

  factory DisplayNameState.initial() {
    return const DisplayNameState(
      pageState: PageState.initial,
      errorMessage: null,
      privateKey: null,
    );
  }
}
