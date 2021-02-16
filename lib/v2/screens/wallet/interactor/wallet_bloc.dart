import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/usecases/get_explore_page_data_use_case.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';
import 'package:seeds/v2/screens/wallet/interactor/usecases/get_wallet_page_data_use_case.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/wallet_events.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/wallet_state.dart';

import 'mappers/wallet_state_mapper.dart';

/// --- BLOC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial());

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is LoadWallet) {
      yield state.copyWith(pageState: PageState.loading);

      Result result = await GetWalletUseCase().run(event.userName);
      yield WalletStateMapper().mapToState(state, result);
    }
  }
}
