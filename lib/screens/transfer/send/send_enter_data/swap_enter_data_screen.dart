import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_bloc.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/error_dialog.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/msig_proposal_action.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/send_loading_indicator.dart';
import 'package:seeds/components/text_form_field_light.dart';
import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/models/eos_action.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/generic_transaction_success_dialog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/components/send_confirmation_dialog.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/show_send_confirm_dialog_data.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:seeds/utils/observer_utils.dart';


class SwapTxArgs {
   Map<String, String?>? selectedAccounts;
   String? sendingToken;
   String? deliveryToken;
   TokenDataModel? swapSendAmount;
   TokenDataModel? swapDeliverAmount;
   String? memo;

   double? senderBalance;
   BuildContext? context;

SwapTxArgs({this.selectedAccounts, this.sendingToken, this.deliveryToken,
  this.swapSendAmount, this.swapDeliverAmount, this.memo, this.senderBalance, this.context});

}

class SwapEnterDataScreen extends StatelessWidget with RouteAware {
  final keyDeliverAmount = GlobalKey<AmountEntryWidgetState>();
  final keySendAmount = GlobalKey<AmountEntryWidgetState>();
  late TransferExpertBloc txbloc;
  late SwapTxArgs args;
  SwapEnterDataScreen({super.key});

  @override
  void didPush() {
    txbloc.add(SwapPresetPageCommand());
  }


  @override
  Widget build(BuildContext context) {
    bool sendFieldHasFocus = false;
    bool deliverFieldHasFocus = false;
    args = ModalRoute.of(context)!.settings.arguments as SwapTxArgs;
    final senderBalance = args.senderBalance!; // TODO: if null, get balance
    final fromContext = args.context!;
    txbloc = BlocProvider.of<TransferExpertBloc>(fromContext);
    ObserverUtils.routeObserver.subscribe(this, ModalRoute.of(context)!); // how to dispose??

    return BlocListener<TransferExpertBloc, TransferExpertState>(
        bloc: BlocProvider.of<TransferExpertBloc>(fromContext),
        listenWhen: (previous, current) =>  !(current.pageCommand is NoCommand),
        listener: (context, state) {
          final PageCommand? command = state.pageCommand;
          if (command is SwapPreset) {
            keyDeliverAmount.currentState!.pushText(args.swapDeliverAmount!.amountString());
            BlocProvider.of<TransferExpertBloc>(fromContext).add(OnSwapInputAmountChange(
              newAmount: args.swapDeliverAmount?.amount ?? 9.9,
              selected: "to", otherKey: keySendAmount));
          } else if (command is NavigateToSendConfirmation) {
            final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
            //BlocProvider.of<SendConfirmationBloc>(pageContext).add(OnAuthorizationFailure(rates));
            NavigationService.of(context).navigateTo(Routes.sendConfirmation, command.arguments, true); // SendConfirmationScreen
          } else if (command is ShowTransferSuccess) {
            Navigator.of(context).pop(); // pop send
            Navigator.of(context).pop(); // pop scanner
            if (command.shouldShowInAppReview) {
              InAppReview.instance.requestReview();
              settingsStorage.saveDateSinceRateAppPrompted(DateTime.now().millisecondsSinceEpoch);
            }
            SendTransactionSuccessDialog.fromPageCommand(command).show(context);
          } else if (command is ShowTransactionSuccess) {
            Navigator.of(context).pop(); // pop send
            Navigator.of(context).pop(); // pop scanner
            GenericTransactionSuccessDialog(command.transactionModel).show(context);
          }
          BlocProvider.of<TransferExpertBloc>(fromContext).add(const ClearPageCommand());

        },

    child: BlocBuilder<TransferExpertBloc, TransferExpertState>(
      bloc: BlocProvider.of<TransferExpertBloc>(fromContext),
      builder: (context, state) {
        final proxySend = state.selectedAccounts["from"] != settingsStorage.accountName;
        return
     Scaffold(
      appBar: AppBar(
        title: Text("Send Abroad"),//Text(context.loc.transferSendSearchTitle),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 30),
            onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: 
          SafeArea(
                    minimum: const EdgeInsets.all(horizontalEdgePadding),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

   //////// Delivered tokens                           
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  //context.loc.transferSendSendTo,
                                  "Deliver ${state.deliveryToken.split('#')[2]} to",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SearchResultRow(member: ProfileModel.usingDefaultValues(
                                account: state.selectedAccounts["to"] ?? '----')
                              ),
                              const SizedBox(height: 4),
                              AmountEntryWidget(
                                key: keyDeliverAmount,
                                tokenDataModel: state.swapDeliverAmount!,
                                onValueChange: (value) {
                                  final newAmount = double.tryParse(value);
                                  if (newAmount != null && deliverFieldHasFocus) {
                                    BlocProvider.of<TransferExpertBloc>(fromContext)
                                      .add(OnSwapInputAmountChange(newAmount: newAmount, selected: "to", otherKey: keySendAmount));
                                  }
                                },
                                autoFocus: true, //state.pageState == PageState.initial,
                                fieldName: "to",
                                onFocusChanged: (hasFocus) {
                                  deliverFieldHasFocus = hasFocus;
                                },
                              ),

   /////////// memo
                              const SizedBox(height: 8),
                              Column(
                                children: [
                                  TextFormFieldLight(
                                    initialText: args?.memo, 
                                    labelText: context.loc.transferMemoFieldLabel,
                                    hintText: context.loc.transferMemoFieldHint,
                                    maxLength: blockChainMaxChars,
                                    onChanged: (String value) {
                                      BlocProvider.of<TransferExpertBloc>(fromContext).add(OnMemoChange(memoChanged: value));
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                ],
                              ),

///////////  Sending tokens
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        //ctxt.loc.transferSendSendTo,
                                        "Send ${state.sendingToken.split('#')[2]}"
                                          + (proxySend ? " From" : ""),
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                    ),

                                    const SizedBox(height: 8),
                                    if (proxySend) 
                                    SearchResultRow(member: ProfileModel.usingDefaultValues(
                                      account: state.selectedAccounts["from"] ?? '----'),
                                    ),
                                    const SizedBox(height: 4),
                                    AmountEntryWidget(
                                      key: keySendAmount,
                                      tokenDataModel: state.swapSendAmount!,
                                      onValueChange: (value) {
                                        final newAmount = double.tryParse(value);
                                        if (newAmount != null && sendFieldHasFocus ) {
                                          //availableBalanceExceeded = newAmount > senderBalance;
                                          BlocProvider.of<TransferExpertBloc>(fromContext)
                                           .add(OnSwapInputAmountChange(newAmount: newAmount, selected: "from", otherKey: keyDeliverAmount));
                                        }
                                      },
                                      autoFocus: false, //state.pageState == PageState.initial,
                                      fieldName: "from",
                                      onFocusChanged: (hasFocus) {
                                        sendFieldHasFocus = hasFocus;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    AlertInputValue(context.loc.transferSendNotEnoughBalanceAlert,
                                      isVisible: (state.swapSendAmount?.amount ?? 0) > senderBalance!), 
                                    const SizedBox(height: 16),

                                  
                                  BalanceRow(
                                    label: context.loc.transferSendAvailableBalance,
                                    fiatAmount: FiatDataModel(111), // state.availableBalanceFiat,
                                    tokenAmount: TokenDataModel.from(senderBalance, token: state.swapSendAmount!.token)
                                  ),
                                  
                                  const SizedBox(height: 100),

                                  ]
                                ),
                          
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButtonLong(
                            title: context.loc.transferSendNextButtonTitle,
                            enabled: true,//state.isNextButtonEnabled,
                            onPressed: () {
                              //eventBus.fire(ShowSnackBar("Swap transaction not implemented"));
                              BlocProvider.of<TransferExpertBloc>(fromContext).add(OnSwapNextButtonTapped(state));
                            },
                          ),
                        ),

              ]
            )
          )    
      );

     }
    
    )
    );
  }
}
