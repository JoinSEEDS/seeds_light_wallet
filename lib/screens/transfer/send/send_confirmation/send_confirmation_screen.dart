import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/components/error_dialog.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/send_loading_indicator.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/generic_transaction_success_dialog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/send_transaction_success_dialog.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/transaction_action_card.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_bloc.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/send_enter_data_screen.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SendConfirmationScreen extends StatelessWidget {
  const SendConfirmationScreen({super.key});


  @override
  Widget build(BuildContext pageContext) {
    final arguments = ModalRoute.of(pageContext)!.settings.arguments! as SendConfirmationArguments;
    return BlocProvider(
      create: (_) => SendConfirmationBloc(arguments)
        ..add(const OnInitValidations()),
      child: BlocBuilder<SendConfirmationBloc, SendConfirmationState>(
        builder: (context, state) {
          /*BlocProvider.value(
            value: BlocProvider.of<SendConfirmationBloc>(pageContext),
            child: SendEnterDataScreen(),);*/
          return WillPopScope(
            onWillPop: () async {
              // Clear deeplink on navigate back (i.e. cancel confirm link)
              BlocProvider.of<DeeplinkBloc>(context).add(const ClearDeepLink());
              Navigator.of(context).pop(state.transactionResult);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(title: const Text('Back')),
              body: MultiBlocListener(
                listeners: [       
                  BlocListener<SendConfirmationBloc, SendConfirmationState>(
                    listenWhen: (_, current) => current.pageCommand != null,
                    listener: (context, state) {
                      final pageCommand = state.pageCommand;
                      // Clear deeplink despite the submit result
                      BlocProvider.of<DeeplinkBloc>(context).add(const ClearDeepLink());

                      if (pageCommand is ShowTransferSuccess) {
                        Navigator.of(context).pop(state.transactionResult);
                        if (pageCommand.shouldShowInAppReview) {
                          InAppReview.instance.requestReview();
                          settingsStorage.saveDateSinceRateAppPrompted(DateTime.now().millisecondsSinceEpoch);
                        }
                        SendTransactionSuccessDialog.fromPageCommand(pageCommand).show(context);
                      } else if (pageCommand is ShowTransactionSuccess) {
                        Navigator.of(context).pop(state.transactionResult);
                        GenericTransactionSuccessDialog(pageCommand.transactionModel).show(context);
                      } else if (pageCommand is ShowFailedTransactionReason) {
                        ErrorDialog(
                          title: pageCommand.title,
                          details: pageCommand.details,
                          onRightButtonPressed: () {
                            final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                            BlocProvider.of<SendConfirmationBloc>(context).add(OnSendTransactionButtonPressed(rates));
                          },
                          bottomButtonText: (pageCommand.failureClass == "canMsig") ?
                            "Retry as Msig Proposal" : null,
                          onBottomButtonPressed: (pageCommand.failureClass == "canMsig") ?
                            () {
                              final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                              BlocProvider.of<SendConfirmationBloc>(context).add(OnAuthorizationFailure(rates));
                              Navigator.of(context).pop();
                            } : null,
                        ).show(context);
                      } else if (pageCommand is RetryAsMsig) {
                        final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                        BlocProvider.of<SendConfirmationBloc>(context).add(OnAuthorizationFailure(rates));
                      } else if (pageCommand is ShowInvalidTransactionReason) {
                        eventBus.fire(ShowSnackBar(pageCommand.reason));
                      }
                    },
                  ),
                  /*BlocListener<SendEnterDataBloc, SendEnterDataState>(
                    //bloc: BlocProvider.of<SendEnterDataBloc>(context),
                    listenWhen: (_, current) => current.retryMsig == true,
                    listener: (ctxt, state) {
                      if (state.retryMsig == true) {
                        final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                        BlocProvider.of<SendConfirmationBloc>(context).add(OnAuthorizationFailure(rates, context: context));
                      }
                    }
                  )*/
                ],
                child:
                BlocBuilder<SendConfirmationBloc, SendConfirmationState>(
                  builder: (context, state) {
                    switch (state.pageState) {
                      case PageState.loading:
                        return state.isTransfer ? const SendLoadingIndicator() : const FullPageLoadingIndicator();
                      case PageState.failure:
                        return FullPageErrorIndicator(errorMessage: state.errorMessage);
                      case PageState.success:
                        return SafeArea(
                          minimum: const EdgeInsets.all(horizontalEdgePadding),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 32.0, top: 20),
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration:
                                            const BoxDecoration(color: AppColors.darkGreen2, shape: BoxShape.circle),
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
                                  enabled: state.invalidTransaction == InvalidTransaction.none,
                                  title: context.loc.transferConfirmationButton,
                                  onPressed: () {
                                    final RatesState rates = BlocProvider.of<RatesBloc>(context).state;
                                    BlocProvider.of<SendConfirmationBloc>(context)
                                        .add(OnSendTransactionButtonPressed(rates));
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  }
                ),
            ),
            )
          );
        },
      ),
    );
  }
}
