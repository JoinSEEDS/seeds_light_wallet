import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/alert_input_value.dart';
import 'package:seeds/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/send_loading_indicator.dart';
import 'package:seeds/components/text_form_field_light.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/transfer/transfer.i18n.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/generic_transaction_success_diaog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/components/send_confirmation_dialog.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/send_enter_data_bloc.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_events.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/show_send_confirm_dialog_data.dart';

/// SendEnterDataScreen SCREEN
class SendEnterDataScreen extends StatelessWidget {
  const SendEnterDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MemberModel memberModel = ModalRoute.of(context)!.settings.arguments! as MemberModel;
    final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
    return BlocProvider(
      create: (_) => SendEnterDataPageBloc(memberModel, rates)..add(InitSendDataArguments()),
      child: BlocListener<SendEnterDataPageBloc, SendEnterDataPageState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final PageCommand? command = state.pageCommand;

          BlocProvider.of<SendEnterDataPageBloc>(context).add(ClearPageCommand());

          if (command is ShowSendConfirmDialog) {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button
              builder: (BuildContext buildContext) => SendConfirmationDialog(
                onSendButtonPressed: () {
                  BlocProvider.of<SendEnterDataPageBloc>(context).add(OnSendButtonTapped());
                },
                tokenAmount: command.tokenAmount,
                fiatAmount: command.fiatAmount,
                toAccount: command.toAccount,
                toImage: command.toImage,
                toName: command.toName,
                memo: command.memo,
              ),
            );
          } else if (command is ShowTransferSuccess) {
            if (command.shouldShowInAppReview) {
              InAppReview.instance.requestReview();
              settingsStorage.saveDateSinceLastAsked(DateTime.now().millisecondsSinceEpoch);
            }

            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button
              builder: (BuildContext buildContext) => SendTransactionSuccessDialog.fromPageCommand(
                onCloseButtonPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                pageCommand: command,
              ),
            );
          } else if (command is ShowTransactionSuccess) {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button
              builder: (BuildContext buildContext) => GenericTransactionSuccessDialog(
                transactionModel: command.transactionModel,
                onCloseButtonPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Send".i18n), backgroundColor: Colors.transparent),
          extendBodyBehindAppBar: true,
          body: BlocBuilder<SendEnterDataPageBloc, SendEnterDataPageState>(
            buildWhen: (_, current) => current.pageCommand == null,
            builder: (context, state) {
              switch (state.pageState) {
                case PageState.initial:
                  return const SizedBox.shrink();
                case PageState.loading:

                  /// We want to show special animation only when the user confirms send.
                  return state.showSendingAnimation
                      ? const SendLoadingIndicator()
                      : const SafeArea(child: FullPageLoadingIndicator());
                case PageState.failure:
                  return const SafeArea(child: FullPageErrorIndicator());
                case PageState.success:
                  return SafeArea(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, top: 10),
                                child: Text(
                                  "Send to".i18n,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SearchResultRow(member: memberModel),
                              const SizedBox(height: 16),
                              AmountEntryWidget(
                                tokenDataModel: TokenDataModel(0, token: settingsStorage.selectedToken),
                                onValueChange: (value) {
                                  BlocProvider.of<SendEnterDataPageBloc>(context)
                                      .add(OnAmountChange(amountChanged: value));
                                },
                                autoFocus: state.pageState == PageState.initial,
                              ),
                              const SizedBox(height: 24),
                              AlertInputValue('Not enough balance'.i18n, isVisible: state.showAlert),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Column(
                                  children: [
                                    TextFormFieldLight(
                                      labelText: "Memo".i18n,
                                      hintText: "Add a note".i18n,
                                      maxLength: blockChainMaxChars,
                                      onChanged: (String value) {
                                        BlocProvider.of<SendEnterDataPageBloc>(context)
                                            .add(OnMemoChange(memoChanged: value));
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    BalanceRow(
                                      label: "Available Balance".i18n,
                                      fiatAmount: state.availableBalanceFiat,
                                      tokenAmount: state.availableBalance,
                                    ),
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButtonLong(
                              title: 'Next'.i18n,
                              enabled: state.isNextButtonEnabled,
                              onPressed: () {
                                BlocProvider.of<SendEnterDataPageBloc>(context).add(OnNextButtonTapped());
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
