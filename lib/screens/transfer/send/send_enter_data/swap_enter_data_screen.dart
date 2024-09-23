import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/amount_entry/amount_entry_widget.dart';
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


class SwapEnterDataArgs {
  final BuildContext context;
  final double senderBalance;

  SwapEnterDataArgs({required this.context, required this.senderBalance});
}

class SwapEnterDataScreen extends StatelessWidget {
  const SwapEnterDataScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    bool sendFieldHasFocus = false;
    bool deliverFieldHasFocus = false;
    final args = ModalRoute.of(context)!.settings.arguments as SwapEnterDataArgs;
    final fromContext = args.context;
    final senderBalance = args.senderBalance;
    BuildContext? toAmountEntryContext;


    return BlocListener<TransferExpertBloc, TransferExpertState>(
        bloc: BlocProvider.of<TransferExpertBloc>(fromContext),
        listenWhen: (_, current) => current.pageCommand != null && !(current.pageCommand is NoCommand),
        listener: (context, state) {
          final PageCommand? command = state.pageCommand;
          //BlocProvider.of<TransferExpertBloc>(context).add(const ClearPageCommand());
          if (command is NavigateToSendConfirmation) {
            final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
            //BlocProvider.of<SendConfirmationBloc>(pageContext).add(OnAuthorizationFailure(rates));
            NavigationService.of(context).navigateTo(Routes.sendConfirmation, command.arguments, true); // SendConfirmationScreen
          }  else if (command is ShowTransferSuccess) {
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
        },

    child: Scaffold(
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
      fromContext == null ? Text("error: no context") :
      BlocProvider.value(
        value: BlocProvider.of<TransferExpertBloc>(fromContext!),
        child: 
          BlocBuilder<TransferExpertBloc, TransferExpertState>(
          builder: (context, state) { 
          final proxySend = state.selectedAccounts["from"] != settingsStorage.accountName;
          return SafeArea(
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
                                tokenDataModel: state.swapDeliverAmount!,
                                onValueChange: (value) {
                                  final newAmount = double.tryParse(value);
                                  if (newAmount != null && deliverFieldHasFocus) {
                                    BlocProvider.of<TransferExpertBloc>(context).add(OnSwapInputAmountChange(newAmount: newAmount, selected: "to"));
                                  }
                                },
                                autoFocus: state.pageState == PageState.initial,
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
                                    labelText: context.loc.transferMemoFieldLabel,
                                    hintText: context.loc.transferMemoFieldHint,
                                    maxLength: blockChainMaxChars,
                                    onChanged: (String value) {
                                      BlocProvider.of<TransferExpertBloc>(context).add(OnMemoChange(memoChanged: value));
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
                                      tokenDataModel: state.swapSendAmount!,
                                      onValueChange: (value) {
                                        final newAmount = double.tryParse(value);
                                        if (newAmount != null && sendFieldHasFocus ) {
                                          //availableBalanceExceeded = newAmount > senderBalance;
                                          BlocProvider.of<TransferExpertBloc>(context).add(OnSwapInputAmountChange(newAmount: newAmount, selected: "from"));
                                        }
                                      },
                                      autoFocus: state.pageState == PageState.initial,
                                      fieldName: "from",
                                      onFocusChanged: (hasFocus) {
                                        sendFieldHasFocus = hasFocus;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    AlertInputValue(context.loc.transferSendNotEnoughBalanceAlert,
                                      isVisible: (state.swapSendAmount?.amount ?? 0) > senderBalance), 
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
                              BlocProvider.of<TransferExpertBloc>(context).add(OnSwapNextButtonTapped(state));
                            },
                          ),
                        ),

              ]
            )
          );
        }
      )
      )
    )
    );
  }
}
