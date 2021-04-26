import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class DisplayNameState extends Equatable {
  final PageState? pageState;
  final String? errorMessage;
  final String? invSecret;


  const DisplayNameState({@required this.pageState, this.errorMessage, this.invSecret});

  @override
  List<Object?> get props => [pageState, errorMessage, invSecret];

  DisplayNameState copyWith({
    PageState? pageState,
    String? errorMessage,
    String? invSecret,
  }) {
    return DisplayNameState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage ?? this.errorMessage,
      invSecret: invSecret ?? this.invSecret,
    );
  }

  factory DisplayNameState.initial() {
    return const DisplayNameState(
      pageState: PageState.initial,
      errorMessage: null,
      invSecret: null,
    );
  }
}
