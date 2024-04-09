import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/cache_repository.dart';
import 'package:seeds/datasource/local/member_model_cache_item.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/system_accounts.dart';
import 'package:seeds/screens/wallet/interactor/mappers/member_state_mapper.dart';
import 'package:seeds/screens/wallet/interactor/usecases/load_member_data_usecase.dart';

part 'member_event.dart';
part 'member_state.dart';

const int _cacheExpiryMinutes = 30;

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc(String currentAccount) : super(MemberState.initial(currentAccount)) {
    on<OnLoadMemberData>(_onLoadMemberData);
  }

  Future<void> _onLoadMemberData(OnLoadMemberData event, Emitter<MemberState> emit) async {
    final account = state.currentAccount;
    // handle special system accounts
    if (SystemAccounts.isSystemAccount(account)) {
      emit(state.copyWith(pageState: PageState.success, member: SystemAccounts.getSystemAccount(account)));
      return;
    }
    emit(state.copyWith(pageState: PageState.loading));
    final CacheRepository cacheRepository = const CacheRepository();
    // If we have a cached item, use it
    final cacheItem = await cacheRepository.getMemberCacheItem(account);
    if (cacheItem != null) {
      emit(state.copyWith(pageState: PageState.success, member: cacheItem.member));
      if (cacheItem.refreshTimeStamp < DateTime.now().millisecondsSinceEpoch) {
        return;
      }
    }
    final result = await LoadMemberDataUseCase().run(account);
    // store result in cache
    if (!result.isError && result.asValue != null && result.asValue!.value is ProfileModel) {
      final ProfileModel member = result.asValue!.value as ProfileModel;
      await cacheRepository.saveMemberCacheItem(
        account,
        MemberModelCacheItem(
            member: member,
            refreshTimeStamp:
                DateTime.now().millisecondsSinceEpoch + Duration.millisecondsPerMinute * _cacheExpiryMinutes),
      );
    }
    emit(MemberStateMapper().mapResultToState(state, result));
  }
}
