import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/send_loading_indicator.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/transfer/transfer.i18n.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/generic_transaction_success_diaog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/transaction_details.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/send_confirmation_bloc.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_info_line_items.dart';
import 'package:seeds/utils/cap_utils.dart';

/// SendConfirmation SCREEN
class SendConfirmationScreen extends StatelessWidget {
  const SendConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SendConfirmationArguments arguments =
        ModalRoute.of(context)!.settings.arguments! as SendConfirmationArguments;

    return BlocProvider(
      create: (_) => SendConfirmationBloc(arguments),
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        )),
        body: BlocListener<SendConfirmationBloc, SendConfirmationState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (BuildContext context, SendConfirmationState state) {
            final pageCommand = state.pageCommand;
            if (pageCommand is ShowTransferSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button
                builder: (BuildContext buildContext) => SendTransactionSuccessDialog.fromPageCommand(
                  onCloseButtonPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  pageCommand: pageCommand,
                ),
              );
            } else if (pageCommand is ShowTransactionSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button
                builder: (BuildContext buildContext) => GenericTransactionSuccessDialog(
                  transactionModel: pageCommand.transactionModel,
                  onCloseButtonPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              );
            }
          },
          child: BlocBuilder<SendConfirmationBloc, SendConfirmationState>(
            builder: (context, SendConfirmationState state) {
              switch (state.pageState) {
                case PageState.loading:
                  return state.isTransfer ? const SendLoadingIndicator() : const FullPageLoadingIndicator();
                case PageState.failure:
                  return const FullPageErrorIndicator();
                case PageState.initial:
                case PageState.success:
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: <Widget>[
                              TransactionDetails(
                                /// This needs to change to use the token icon. right now its hard coded to seeds
                                image: SvgPicture.asset("assets/images/seeds_logo.svg"),
                                // TODO(n13): This needs to show all transaction
                                // Showing only the first transaction here to have a smaller PR
                                // And still functioning code
                                title: state.transaction.actions.first.actionName.inCaps,
                                beneficiary: state.transaction.actions.first.accountName,
                              ),
                              const SizedBox(height: 42),
                              Column(
                                children: <Widget>[
                                  // TODO(n13): Only showing the first action here, should show all actions
                                  ...SendInfoLineItems.fromAction(state.transaction.actions.first)
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.only(top: 16),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                e.label!,
                                                style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                                              ),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                  child: Text(e.text.toString(),
                                                      style: Theme.of(context).textTheme.subtitle2)),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: FlatButtonLong(
                          title: 'Confirm and Send'.i18n,
                          onPressed: () {
                            final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                            BlocProvider.of<SendConfirmationBloc>(context).add(SendTransactionEvent(rates));
                          },
                        ),
                      ),
                    ],
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
