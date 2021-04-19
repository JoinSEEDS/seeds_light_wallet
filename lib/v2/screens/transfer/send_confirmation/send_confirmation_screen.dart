import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/components/transaction_details.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/send_confirmation_bloc.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';
import 'package:seeds/v2/utils/cap_utils.dart';

/// SendConfirmation SCREEN
class SendConfirmationScreen extends StatelessWidget {
  const SendConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SendConfirmationArguments arguments = ModalRoute.of(context)!.settings.arguments! as SendConfirmationArguments;

    return BlocProvider(
      create: (context) => SendConfirmationBloc(arguments)..add(InitSendConfirmationWithArguments()),
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )),
        body: BlocListener<SendConfirmationBloc, SendConfirmationState>(
          listenWhen: (context, SendConfirmationState state) => state.pageCommand != null,
          listener: (BuildContext context, SendConfirmationState state) {
            if (state.pageCommand is ShowTransactionSuccess) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button
                builder: (BuildContext buildContext) => SendTransactionSuccessDialog(
                    amount: state.pageCommand!.amount,
                    fiatAmount: state.pageCommand!.fiatAmount,
                    fromAccount: state.pageCommand!.fromAccount,
                    fromImage: state.pageCommand!.fromImage,
                    fromName: state.pageCommand!.fromName,
                    toAccount: state.pageCommand!.toAccount,
                    toImage: state.pageCommand!.toImage,
                    toName: state.pageCommand!.toName,
                    transactionID: state.pageCommand!.transactionId),
              );
            }
          },
          child: BlocBuilder<SendConfirmationBloc, SendConfirmationState>(
            builder: (context, SendConfirmationState state) {
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
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: <Widget>[
                              TransactionDetails(
                                /// This needs to change to use the token icon. right now its hard coded to seeds
                                image: SvgPicture.asset("assets/images/seeds_logo.svg"),
                                title: state.name!.inCaps,
                                beneficiary: state.account,
                              ),
                              const SizedBox(height: 42),
                              Column(
                                children: <Widget>[
                                  ...state.lineItems!
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.only(top: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                e.label!,
                                                style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                                              ),
                                              Text(e.text.toString(), style: Theme.of(context).textTheme.subtitle2),
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
                          title: 'Confirm and Send',
                          onPressed: () {
                            RatesState rates = BlocProvider.of<RatesBloc>(context).state;
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
