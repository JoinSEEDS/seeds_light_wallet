import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/send_loading_indicator.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/transfer/transfer.i18n.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/generic_transaction_success_diaog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/transaction_action_card.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';

/// SendConfirmation SCREEN
class SendConfirmationScreen extends StatelessWidget {
  const SendConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments! as SendConfirmationArguments;
    return BlocProvider(
      create: (_) => SendConfirmationBloc(arguments),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Back')),
          body: BlocConsumer<SendConfirmationBloc, SendConfirmationState>(
            listenWhen: (_, current) => current.pageCommand != null,
            listener: (context, state) {
              final pageCommand = state.pageCommand;
              if (pageCommand is ShowTransferSuccess) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button
                  builder: (_) => SendTransactionSuccessDialog.fromPageCommand(
                    onCloseButtonPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    pageCommand: pageCommand,
                  ),
                );
              } else if (pageCommand is ShowTransactionSuccess) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button
                  builder: (_) => GenericTransactionSuccessDialog(
                    transactionModel: pageCommand.transactionModel,
                    onCloseButtonPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  ),
                );
              }
            },
            builder: (context, state) {
              switch (state.pageState) {
                case PageState.loading:
                  return state.isTransfer ? const SendLoadingIndicator() : const FullPageLoadingIndicator();
                case PageState.failure:
                  return const FullPageErrorIndicator();
                case PageState.initial:
                case PageState.success:
                  return SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 24),
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32.0, top: 20),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: const BoxDecoration(color: AppColors.darkGreen2, shape: BoxShape.circle),
                                  child: SvgPicture.asset("assets/images/seeds_logo.svg"),
                                ),
                              ),
                              for (final i in state.transaction.actions) TransactionActionCard(i)
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FlatButtonLong(
                            title: 'Confirm and Send'.i18n,
                            onPressed: () {
                              final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                              BlocProvider.of<SendConfirmationBloc>(context).add(OnSendTransactionButtonPressed(rates));
                            },
                          ),
                        ),
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
