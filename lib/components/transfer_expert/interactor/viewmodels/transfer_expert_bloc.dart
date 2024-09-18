import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/components/transfer_expert/interactor/mappers/transfer_expert_state_mapper.dart';
import 'package:seeds/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/model/eos_account_model.dart';
import 'package:seeds/datasource/remote/model/oswap_model.dart';
import 'package:seeds/datasource/remote/api/eosaccount_repository.dart';
import 'package:seeds/datasource/remote/api/oswaps_repository.dart';

import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/page_state.dart';


part 'transfer_expert_event.dart';
part 'transfer_expert_state.dart';

class TransferExpertBloc extends Bloc<TransferExpertEvent, TransferExpertState> {
  final int _minTextLengthBeforeValidSearch = 2;
  final _eosaccountrepository = EOSAccountRepository();
  final _oswapPool = OswapModel().loadTest(); //.initTest();
  final _oswapsRepository = OswapsRepository();
  final _balanceRepository = BalanceRepository();


  TransferExpertBloc(List<String>? noShowUsers, ProfileStatus? filterByCitizenshipStatus)
      : super(TransferExpertState.initial(noShowUsers, filterByCitizenshipStatus)) {
    on<OnSearchChange>(_onSearchChange, transformer: _transformEvents);
    on<ClearIconTapped>(_clearIconTapped);
    on<OnDeliveryTokenChange>(_onDeliveryTokenChange);
    on<OnSwapInputAmountChange>(_onSwapInputAmountChange);
    on<OnOSwapLoad>(_onOSwapLoad);
  }

  /// Debounce to avoid making search network calls each time the user types
  /// switchMap: To remove the previous event. Every time a        print('From ${state.selectedAccounts["from"]}'); new Stream is created, the previous Stream is discarded.
  Stream<OnSearchChange> _transformEvents(
      Stream<OnSearchChange> events, Stream<OnSearchChange> Function(OnSearchChange) transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 300)).switchMap(transitionFn);
  }

  Future<void> _onSearchChange(OnSearchChange event, Emitter<TransferExpertState> emit) async {
    final newSelectedAccounts = Map<String, String>.from(state.selectedAccounts);
    newSelectedAccounts[event.accountKey] = event.searchQuery;
    List<String> newValidChainAccounts = List<String>.from(state.validChainAccounts);
    final accountModel = (await _eosaccountrepository.getEOSAccount(event.searchQuery)).asValue?.value;
    accountModel != null ?
      newValidChainAccounts.add(event.accountKey)
      : newValidChainAccounts.remove(event.accountKey);
    emit(state.copyWith(
      pageState: PageState.loading,
      showClearIcon: event.searchQuery.isNotEmpty,
      selectedAccounts: newSelectedAccounts,
      validChainAccounts: newValidChainAccounts,
    ));
  }

  void _onDeliveryTokenChange(OnDeliveryTokenChange event, Emitter<TransferExpertState> emit) {
    emit(state.copyWith(deliveryToken: event.tokenId,
      swapDeliverAmount: TokenDataModel(0.0, token: TokenModel.fromId(event.tokenId)!)));
  }  
  
  void _clearIconTapped(ClearIconTapped event, Emitter<TransferExpertState> emit) {
    emit(TransferExpertState.initial(state.noShowUsers, state.showOnlyCitizenshipStatus));
  }

  void _onSwapInputAmountChange(OnSwapInputAmountChange event, Emitter<TransferExpertState> emit) async {
    TokenDataModel? tokenSendAmount;
    TokenDataModel? tokenDeliverAmount;
    if (event.selected == "from") {
      final sendAmount = TokenDataModel(event.newAmount, token: TokenModel.fromId(state.sendingToken)!).amount;
      tokenSendAmount = TokenDataModel(sendAmount, token: TokenModel.fromId(state.sendingToken)!);
      emit(state.copyWith(swapSendAmount: tokenSendAmount));
      final swapout = _oswapPool.swapOutput(inTokenId: state.sendingToken, inAmount: sendAmount,
        outTokenId: state.deliveryToken);
      print('swap output ${swapout.error}, ${swapout.result}');
      if (swapout.error == null) {
        tokenDeliverAmount = TokenDataModel(swapout.result!, token: TokenModel.fromId(state.deliveryToken)!);
        emit(state.copyWith(swapDeliverAmount: tokenDeliverAmount));
      }
    } 
    if (event.selected == "to") {
      final deliverAmount = TokenDataModel(event.newAmount, token: TokenModel.fromId(state.deliveryToken)!).amount;
      tokenDeliverAmount = TokenDataModel(deliverAmount, token: TokenModel.fromId(state.deliveryToken)!);
      emit(state.copyWith(swapDeliverAmount: tokenDeliverAmount));
      final swapout = _oswapPool.swapOutput(inTokenId: state.sendingToken, outAmount: deliverAmount,
        outTokenId: state.deliveryToken);
      print('swap output ${swapout.error}, ${swapout.result}');
      if (swapout.error == null) {
        tokenSendAmount = TokenDataModel(swapout.result!, token: TokenModel.fromId(state.sendingToken)!);
        emit(state.copyWith(swapSendAmount: tokenSendAmount));
      }
    }
  }  

  void _onOSwapLoad(OnOSwapLoad event, Emitter<TransferExpertState> emit) async {
    final result = await _oswapsRepository.getAssetList();
    if (result.isValue) {
      final list = result.asValue!.value;
      for (var i = 0; i < list.length; ++i) {
        final asset = list[i];
        final balanceModelResult = await _balanceRepository.getTokenBalance(OswapsRepository.defaultPoolContract,
          tokenContract: asset.tokenId.split('#')[1],
          symbol: asset.tokenId.split('#')[2], );
          if(balanceModelResult.isValue) {
            _oswapPool.balances.add(OswapPoolBalance(assetId: asset.assetId, tokenId: asset.tokenId,
                weight: asset.weight, active: asset.active, balance: balanceModelResult.asValue!.value.quantity));
          }  
      };


     //   balances.add(OswapPoolBalance(assetId: 0, tokenId: "Telos#token.seeds#SEEDS", balance: 1000, weight: 0.5));

    }
  }
}
