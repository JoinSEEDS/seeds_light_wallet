import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/components/amount_entry/amount_entry_widget.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/text_form_field_light.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'interactor/receive_enter_data_bloc.dart';
import 'interactor/viewmodels/receive_enter_data_events.dart';
import 'interactor/viewmodels/receive_enter_data_state.dart';

class ReceiveEnterDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReceiveEnterDataBloc(BlocProvider.of<RatesBloc>(context).state)..add(const LoadUserBalance()),
      child: Scaffold(
          appBar: AppBar(title: const Text("Receive")),
          body: BlocConsumer<ReceiveEnterDataBloc, ReceiveEnterDataState>(
              listenWhen: (_, current) => current.pageCommand != null,
              listener: (context, state) {
                // if (state.pageCommand is ShowInviteLinkDialog) {
                //   showDialog<void>(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (_) {
                //       return BlocProvider.value(
                //         value: BlocProvider.of<InviteBloc>(context),
                //         child: const InviteLinkDialog(),
                //       );
                //     },
                //   );
                // }
                // if (state.pageCommand is ShowTransactionFailSnackBar) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBarInfo(title: 'Invite creation failed, try again.'.i18n, context: context),
                //   );
                // }
              },
              builder: (context, ReceiveEnterDataState state) {
                switch (state.pageState) {
                  case PageState.initial:
                    return const SizedBox.shrink();
                  case PageState.loading:
                    return const FullPageLoadingIndicator();
                  case PageState.failure:
                    return const FullPageErrorIndicator();
                  case PageState.success:
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              AmountEntryWidget(
                                onValueChange: (value) {
                                  // BlocProvider.of<ReceiveEnterDataPageBloc>(context)
                                  //     .add(OnAmountChange(amountChanged: value));
                                },
                                autoFocus: true,
                              ),
                              const SizedBox(height: 36),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                                child: Column(
                                  children: [
                                    TextFormFieldLight(
                                      labelText: "Description",
                                      hintText: "Enter Product Details",
                                      maxLength: blockChainMaxChars,
                                      onChanged: (String value) {
                                        // BlocProvider.of<ReceiveEnterDataPageBloc>(context)
                                        //     .add(OnDescriptionChange(descriptionChanged: value));
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    const BalanceRow(
                                      label: "Available Balance",
                                      fiatAmount: "TODO",
                                      seedsAmount: "TODO",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(horizontalEdgePadding),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButtonLong(
                              title: 'Next',
                              enabled: false,
                              onPressed: () {
                                // BlocProvider.of<ReceiveEnterDataPageBloc>(context).add(OnNextButtonTapped());
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  default:
                    return const SizedBox.shrink();
                }
              })),
    );
  }
}
