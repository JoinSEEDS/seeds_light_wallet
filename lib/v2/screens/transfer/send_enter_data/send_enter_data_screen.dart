import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/amount_entry_widget.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/search_user/components/search_result_row.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/components/send_confirmation_dialog.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/send_enter_data_bloc.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_events.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/show_send_confirm_dialog_data.dart';

/// SendEnterDataScreen SCREEN
class SendEnterDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MemberModel memberModel = ModalRoute.of(context)!.settings.arguments! as MemberModel;
    RatesState rates = BlocProvider.of<RatesBloc>(context).state;
    return BlocProvider(
        create: (context) => SendEnterDataPageBloc(memberModel, rates)..add(InitSendDataArguments()),
        child: BlocListener<SendEnterDataPageBloc, SendEnterDataPageState>(
          listenWhen: (previous, current) => current.pageCommand != null,
          listener: (context, state) {
            var command = state.pageCommand;
            if (command == null) {
              return;
            }

            BlocProvider.of<SendEnterDataPageBloc>(context).add(ClearPageCommand());

            if (command is ShowSendConfirmDialog) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button
                builder: (BuildContext buildContext) => SendConfirmationDialog(
                  onSendButtonPressed: () {
                    BlocProvider.of<SendEnterDataPageBloc>(context).add(OnSendButtonTapped());
                  },
                  amount: command.amount,
                  currency: command.currency,
                  fiatAmount: command.fiatAmount,
                  toAccount: command.toAccount,
                  toImage: command.toImage,
                  toName: command.toName,
                ),
              );
            } else if (command is ShowTransactionSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button
                builder: (BuildContext buildContext) => SendTransactionSuccessDialog(
                    onCloseButtonPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    currency: command.currency,
                    amount: command.amount,
                    fiatAmount: command.fiatAmount,
                    fromAccount: command.fromAccount,
                    fromImage: command.fromImage,
                    fromName: command.fromName,
                    toAccount: command.toAccount,
                    toImage: command.toImage,
                    toName: command.toName,
                    transactionID: command.transactionId),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(),
            body: BlocBuilder<SendEnterDataPageBloc, SendEnterDataPageState>(
              buildWhen: (context, state) {
                return state.pageCommand == null;
              },
                builder: (context, SendEnterDataPageState state) {
              switch (state.pageState) {
                case PageState.initial:
                  return const SizedBox.shrink();
                case PageState.loading:
                  return const FullPageLoadingIndicator();
                case PageState.failure:
                  return const FullPageErrorIndicator();
                case PageState.success:
                  return Column(
                    children: [
                      Text(
                        "Send to",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      SearchResultRow(
                        account: memberModel.account,
                        imageUrl: memberModel.image,
                        name: memberModel.nickname,
                      ),
                      const SizedBox(height: 16),
                      AmountEntryWidget(
                        onValueChange: (value) {
                          BlocProvider.of<SendEnterDataPageBloc>(context).add(OnAmountChange(amountChanged: value));
                        },
                        fiatAmount: state.fiatAmount,
                        enteringCurrencyName: "SEEDS",
                        autoFocus: state.pageState == PageState.initial,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Add a Note",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintMaxLines: 150,
                        ),
                        autofocus: false,
                        onChanged: (String value) {},
                      ),
                      const SizedBox(height: 16),
                      BalanceRow(
                        label: "Available Balance",
                        fiatAmount: state.availableBalanceFiat ?? "",
                        seedsAmount: state.availableBalance ?? "",
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FlatButtonLong(
                              title: 'Next',
                              enabled: state.isNextButtonEnabled,
                              onPressed: () {
                                BlocProvider.of<SendEnterDataPageBloc>(context).add(OnNextButtonTapped());
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ));
  }
}
