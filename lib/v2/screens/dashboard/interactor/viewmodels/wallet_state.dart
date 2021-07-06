import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class WalletState extends Equatable {
  final PageState pageState;

  const WalletState({required this.pageState});

  @override
  List<Object?> get props => [pageState];

  WalletState copyWith({PageState? pageState}) {
    return WalletState(pageState: pageState ?? this.pageState);
  }

  factory WalletState.initial() {
    return const WalletState(pageState: PageState.initial);
  }
}
