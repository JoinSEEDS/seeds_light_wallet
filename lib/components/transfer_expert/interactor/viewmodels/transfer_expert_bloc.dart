import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/transfer_expert/interactor/mappers/send_expert_transaction_mapper.dart';
import 'package:seeds/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:seeds/components/msig_proposal_action.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/models/eos_transaction.dart';
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
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/mappers/send_transaction_mapper.dart';


part 'transfer_expert_event.dart';
part 'transfer_expert_state.dart';

class TransferExpertBloc extends Bloc<TransferExpertEvent, TransferExpertState> {
  final int _minTextLengthBeforeValidSearch = 2;
  final _eosaccountrepository = EOSAccountRepository();
  final oswapPool = OswapModel().loadTest();
  final _oswapsRepository = OswapsRepository();
  final _balanceRepository = BalanceRepository();


  TransferExpertBloc(List<String>? noShowUsers, ProfileStatus? filterByCitizenshipStatus)
      : super(TransferExpertState.initial(noShowUsers, filterByCitizenshipStatus)) {
    on<OnSearchChange>(_onSearchChange, transformer: _transformEvents);
    on<ClearIconTapped>(_clearIconTapped);
    on<OnDeliveryTokenChange>(_onDeliveryTokenChange);
    on<OnSwapInputAmountChange>(_onSwapInputAmountChange);
    on<OnOSwapLoad>(_onOSwapLoad);
    on<OnSwapNextButtonTapped>(_onSwapNextButtonTapped);
  }

  Future<double?> balance(String account, String tokenId) async {
    final balanceModelResult = await _balanceRepository.getTokenBalance(
      account,
      tokenContract: tokenId.split('#')[1],
      symbol: tokenId.split('#')[2], );
    if (balanceModelResult.isError) {
      return null;
    }
    return balanceModelResult.asValue!.value.quantity;
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
    final newAccountPermissions = Map<String, EOSAccountModel?>.from(state.accountPermissions);
    final accountModel = (await _eosaccountrepository.getEOSAccount(event.searchQuery)).asValue?.value;
    newAccountPermissions[event.accountKey] = accountModel;
    accountModel != null ?
      newValidChainAccounts.add(event.accountKey)
      : newValidChainAccounts.remove(event.accountKey);
    emit(state.copyWith(
      pageState: PageState.loading,
      showClearIcon: event.searchQuery.isNotEmpty,
      selectedAccounts: newSelectedAccounts,
      accountPermissions: newAccountPermissions,
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
      final swapout = oswapPool.swapOutput(inTokenId: state.sendingToken, inAmount: sendAmount,
        outTokenId: state.deliveryToken);
      print('swap output ${swapout.error}, ${swapout.result}');
      if (swapout.error == null) {
        tokenDeliverAmount = TokenDataModel(swapout.result!, token: TokenModel.fromId(state.deliveryToken)!);
        emit(state.copyWith(swapDeliverAmount: tokenDeliverAmount));
      } else {
        eventBus.fire(ShowSnackBar(swapout.error!));
      }
    } 
    if (event.selected == "to") {
      final deliverAmount = TokenDataModel(event.newAmount, token: TokenModel.fromId(state.deliveryToken)!).amount;
      tokenDeliverAmount = TokenDataModel(deliverAmount, token: TokenModel.fromId(state.deliveryToken)!);
      emit(state.copyWith(swapDeliverAmount: tokenDeliverAmount));
      final swapout = oswapPool.swapOutput(inTokenId: state.sendingToken, outAmount: deliverAmount,
        outTokenId: state.deliveryToken);
      print('swap output ${swapout.error}, ${swapout.result}');
      if (swapout.error == null) {
        tokenSendAmount = TokenDataModel(swapout.result!, token: TokenModel.fromId(state.sendingToken)!);
        emit(state.copyWith(swapSendAmount: tokenSendAmount));
      } else {
        eventBus.fire(ShowSnackBar(swapout.error!));
      }
    }
  }  

  // TODO: refactor, we should get full asset list when user selects expert mode send
  // and use that to present available options in drop-down list.
  // We need to update asset balances only for the two active assets when we
  // load the send abroad screen
  void _onOSwapLoad(OnOSwapLoad event, Emitter<TransferExpertState> emit) async {
    final result = await _oswapsRepository.getAssetList();
    if (result.isValue) {
      final list = result.asValue!.value;
      for (var i = 0; i < list.length; ++i) {
        final asset = list[i];
        final assetBalance = await balance(OswapsRepository.defaultPoolContract, asset.tokenId);
        if (assetBalance != null) {
          oswapPool.balances.add(OswapPoolBalance(assetId: asset.assetId, tokenId: asset.tokenId,
            weight: asset.weight, active: asset.active, balance: assetBalance));
        }
      };
    }
  }
  
  void _onSwapNextButtonTapped(OnSwapNextButtonTapped event, Emitter<TransferExpertState> emit) async {

    emit(state.copyWith(pageState: PageState.loading, showSendingAnimation: true));
    final esrTransaction = buildOswapTransaction(state, pool: oswapPool);
    if (esrTransaction == null) {
      return;
    }
    final transaction = EOSTransaction.fromESRActionsList(esrTransaction!.actions!.map((e) => e!).toList());

    String failureClass = (await MsigProposal.canMsig(esrTransaction)) ? 'canMsig' : '';
    
    final Result result = await SendTransactionUseCase().run(transaction, null, );
    
    final bool shouldShowInAppReview = await InAppReview.instance.isAvailable();
    
    emit(SendExpertTransactionMapper().mapResultToState(
      currentState: state,
      result: result,
      shouldShowInAppReview: shouldShowInAppReview,
      failureClass: failureClass));
    
  }

 Future<void> _onSwapSendButtonTapped(OnSwapSendButtonTapped event, Emitter<TransferExpertState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, showSendingAnimation: true));

    final esrTransaction = buildOswapTransaction(state, pool: oswapPool);
    if (esrTransaction == null) {
      return; // set result as error?
    }
    final transaction = EOSTransaction.fromESRActionsList(esrTransaction.actions!.map((e) => e!).toList());
    String failureClass = (await MsigProposal.canMsig(esrTransaction)) ? 'canMsig' : '';
    final Result result = await SendTransactionUseCase().run(
      transaction,
      null,
    );
    final bool shouldShowInAppReview = await InAppReview.instance.isAvailable();
 }


  static esr.Transaction?  buildOswapTransaction(TransferExpertState state, { required OswapModel pool, String poolContract = OswapsRepository.defaultPoolContract}) {
      final from = state.selectedAccounts["from"];
      final to = state.selectedAccounts["to"];
      final inAssetId = pool.balances.firstWhereOrNull((bal) => bal.tokenId == state.sendingToken)?.assetId;
      if (inAssetId == null) {
        eventBus.fire(ShowSnackBar('Token ${state.sendingToken.split("#")[2]} is not in swap pool'));
        return null;
      }
      final outAssetId = pool.balances.firstWhereOrNull((bal) => bal.tokenId == state.deliveryToken)?.assetId;
      if (outAssetId == null) {
        eventBus.fire(ShowSnackBar('Token ${state.deliveryToken.split("#")[2]} is not in swap pool'));
        return null;
      }
      // we treat delivery amount as exact
      double margin = 0.02;
      String deliverAmount =  TokenModel.getAssetString(state.swapDeliverAmount!.id, state.swapDeliverAmount!.amount);
      String sendAmount =  TokenModel.getAssetString(state.swapSendAmount!.id, state.swapSendAmount!.amount*(1.0 + margin));

      var exprep = esr.Action()
            ..account = poolContract
            ..name = "exprepto"
            ..data = {
              'sender': from,
              'recipient': to,
              'in_token_id': inAssetId,
              'out_token_id': outAssetId,
              'out_amount': deliverAmount,
              'memo': "swap", //state.memo,
            }
            ..authorization = [
              esr.Authorization()
                ..actor = from
                ..permission = "active"
            ];

      return esr.Transaction()
        ..actions = [
          exprep,
          
          esr.Action()
            ..account = state.swapSendAmount!.id!.split('#')[1]
            ..name = "transfer"
            ..data = {
              'from': from,
              'to': poolContract,
              'quantity': sendAmount,
              'memo': "swap", //state.memo,
            }
            ..authorization = [
              esr.Authorization()
                ..actor = from
                ..permission = "active"
            ]
            
        ];
  }


}

