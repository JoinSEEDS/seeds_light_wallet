import 'dart:math';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/msig_proposal_action.dart';
import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/models/eos_action.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/eos_permissions_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/datasource/remote/model/transaction_results.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/initial_validation_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/swap_enter_data_screen.dart';

part 'send_confirmation_event.dart';
part 'send_confirmation_state.dart';

class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  final InAppReview inAppReview = InAppReview.instance;

  SendConfirmationBloc(SendConfirmationArguments arguments) : super(SendConfirmationState.initial(arguments)) {
    on<OnInitValidations>(_onInitValidations);
    on<OnSendTransactionButtonPressed>(_onSendTransaction);
    on<OnAuthorizationFailure>(_onAuthorizationFailure);
    on<OnMakeForeignButtonPressed>(_onMakeForeignButtonPressed);
  }

  Future<void> _onInitValidations(OnInitValidations event, Emitter<SendConfirmationState> emit) async {
    // We can extend this initial validation logic in future using a switch case for any transaction type
    // for now it only validates a transfer
    if (state.isTransfer) {
      final eosAction = state.transaction.actions.first;
      final symbol = (eosAction.data?['quantity'] as String).split(' ').last;
      final contract = eosAction.account;
      var targetToken = TokenModel.allTokens.
          singleWhereOrNull((i) => i.symbol == symbol && i.contract == contract);
      targetToken ??= TokenModel(
        chainName: "Telos",
        contract: eosAction.account!,
        symbol: symbol,
        name: eosAction.name!,
        backgroundImageUrl: '',
        logoUrl: '',
        balanceSubTitle: 'Wallet Balance',
        overdraw: '',
        precision: 4,
        usecases: [],
      );
      final Result<BalanceModel> result = await GetAvailableBalanceUseCase()
        .run(targetToken, account: eosAction.data?['from'] as String);
      emit(InitialValidationStateMapper().mapResultToState(state, result));
    } else {
      emit(state.copyWith(pageState: PageState.success));
    }
  }

  Future<void> _onSendTransaction(OnSendTransactionButtonPressed event, Emitter<SendConfirmationState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    // check whether this transaction has multisig signers available
    //  leave a breadcrumb in case it fails after submission
    String failureClass = '';
    final auth = state.transaction.actions?[0]?.authorization?.map((e) => 
                      esr.Authorization() ..actor = e?.actor ..permission = e?.permission ).toList()?[0];
    if (auth != null && await MsigProposal.signingAccounts(auth: auth!) != null) { 
      failureClass = "canMsig";
    }
    final Result result = await SendTransactionUseCase().run(state.transaction, state.callback);
    final bool shouldShowInAppReview = await inAppReview.isAvailable();
    emit(SendTransactionStateMapper().mapResultToState(currentState: state, result: result,
      rateState: event.rates, shouldShowInAppReview: shouldShowInAppReview, failureClass: failureClass));
  }
  
  Future<void> _onAuthorizationFailure(OnAuthorizationFailure event, Emitter<SendConfirmationState> emit) async {
    final auth = state.transaction.actions[0]?.authorization?.map((e) => 
            esr.Authorization() ..actor = e?.actor ..permission = e?.permission ).toList();
    if (auth != null && auth.length > 0) {

      final msigESRAction = 
        await MsigProposal.msigProposalAction(
          actions: state.transaction.actions.map((e) =>
            esr.Action()
            ..account = e.account
            ..name = e.name
            ..data = e.data
            ..authorization = e.authorization?.map((e) => 
              esr.Authorization() ..actor = e?.actor ..permission = e?.permission ).toList()
          ).toList(),
          auth: auth,
          proposer: settingsStorage.accountName,
          proposalName: 'seeds${MsigProposal.RandomName(length: 5)}',
        );
        if (msigESRAction != null) {
          final msigTransaction = EOSTransaction([ EOSAction.fromESRAction(msigESRAction!) ]);
          emit(state.copyWith(
            pageState: PageState.success, transaction: msigTransaction));
        } else {
          eventBus.fire(ShowSnackBar("Cannot create msig proposal for this transaction."));
        }
    } else {
      eventBus.fire(ShowSnackBar("Cannot create msig proposal for this transaction."));
    }
  }


  Future<void> _onMakeForeignButtonPressed(OnMakeForeignButtonPressed event, Emitter<SendConfirmationState> emit) async {
    // collect data to launch swap transaction (transferExpert route = send_expert_screen)
    
    final transactionData = state.transaction.actions[0].data!;
    final contract = state.transaction.actions[0].account;
    final symbol = transactionData["quantity"].split(" ")[1] as String;
    final tokenId = 'Telos#${contract}#${symbol}';

    SwapTxArgs args = SwapTxArgs( 
      selectedAccounts: {"to": transactionData["to"] as String, "from": transactionData["from"] as String},
      sendingToken: settingsStorage.selectedToken.id,
      deliveryToken: tokenId,
      swapDeliverAmount: TokenDataModel(
        double.parse(transactionData["quantity"].split(" ")[0] as String),
        token: TokenModel.fromId(tokenId)!),
      memo: transactionData["memo"] as String,
      );
    NavigationService.of(event.context).navigateTo(Routes.transferExpert, args, false);

  }
}
