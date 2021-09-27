import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/import_key_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/mappers/find_accounts_result_state_mapper.dart';

part 'switch_account_event.dart';
part 'switch_account_state.dart';

class SwitchAccountBloc extends Bloc<SwitchAccountEvent, SwitchAccountState> {
  SwitchAccountBloc() : super(SwitchAccountState.initial());

  @override
  Stream<SwitchAccountState> mapEventToState(SwitchAccountEvent event) async* {
    if (event is FindAccountsByKey) {
      yield state.copyWith(pageState: PageState.loading);
      final publicKey = CheckPrivateKeyUseCase().isKeyValid(settingsStorage.privateKey!);
      if (publicKey == null || publicKey.isEmpty) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid".i18n);
      } else {
        final results = await ImportKeyUseCase().run(publicKey);
        yield FindAccountsResultStateMapper().mapResultsToState(state, results);
      }
    } else if (event is OnAccountSelected) {}
  }
}
