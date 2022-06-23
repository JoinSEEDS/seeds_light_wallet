import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_user_profile_use_case.dart';
import 'package:seeds/screens/wallet/interactor/mappers/user_account_state_mapper.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial()) {
    on<OnLoadWalletData>(_onLoadWalletData);
  }

  Future<void> _onLoadWalletData(OnLoadWalletData event, Emitter<WalletState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await GetUserProfileUseCase().run(settingsStorage.accountName);
    WalletState newState;
    emit(newState = UserAccountStateMapper().mapResultToState(state, result));
    settingsStorage.saveCitizenshipStatus(newState.profile.status);
  }
}
