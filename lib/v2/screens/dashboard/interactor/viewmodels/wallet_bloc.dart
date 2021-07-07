import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/wallet_event.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/wallet_state.dart';

/// --- BLOC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial());

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is OnLoadWalletData) {
      yield state.copyWith(pageState: PageState.loading);
      yield state.copyWith(pageState: PageState.success);
    }
  }
}
