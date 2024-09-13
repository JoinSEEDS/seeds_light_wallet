import 'dart:math';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/msig_proposal_action.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/models/eos_action.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/eos_permissions_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/datasource/remote/model/transaction_results.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/initial_validation_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/navigation/navigation_service.dart';

part 'send_confirmation_event.dart';
part 'send_confirmation_state.dart';

class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  final InAppReview inAppReview = InAppReview.instance;

  SendConfirmationBloc(SendConfirmationArguments arguments) : super(SendConfirmationState.initial(arguments)) {
    on<OnInitValidations>(_onInitValidations);
    on<OnSendTransactionButtonPressed>(_onSendTransaction);
    on<OnAuthorizationFailure>(_onAuthorizationFailure);
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
    final Result result = await SendTransactionUseCase().run(state.transaction, state.callback);
    final bool shouldShowInAppReview = await inAppReview.isAvailable();
    emit(SendTransactionStateMapper().mapResultToState(state, result, event.rates, shouldShowInAppReview));
  }
  
  Future<void> _onAuthorizationFailure(OnAuthorizationFailure event, Emitter<SendConfirmationState> emit) async {
    

      final msigAction = EOSAction.fromESRAction(
        (await
        MsigProposal.msigProposalAction(
          actions: state.transaction.actions.map((e) =>
            esr.Action()
            ..account = e.account
            ..name = e.name
            ..data=e.data
            ..authorization = e.authorization?.map((e) => 
              esr.Authorization() ..actor = e?.actor ..permission = e?.permission ).toList()
          ).toList(),
          auth: state.transaction.actions[0].authorization!.map((e) => 
              esr.Authorization() ..actor = e?.actor ..permission = e?.permission ).toList(),
          proposer: settingsStorage.accountName,
          proposalName: 'testprop${Random().nextInt(5)+1}',
        ))!
        
      );
    final msigTransaction = EOSTransaction([ msigAction ]);
    emit(state.copyWith(pageState: PageState.success, transaction: msigTransaction));
    //final args = SendConfirmationArguments(transaction: msigTransaction);
    //final result = (await NavigationService.of(event.context).navigateTo(Routes.sendConfirmation, args, true)).toString();
 /*
    final Result result = await SendTransactionUseCase().run(state.transaction, state.callback);
    final bool shouldShowInAppReview = await inAppReview.isAvailable();
    emit(SendTransactionStateMapper().mapResultToState(state, result, event.rates, shouldShowInAppReview));
*/
  }
}
