import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/qr_code_generator_widget.dart';
import 'package:seeds/components/share_link_row.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/interactor/viewmodels/receive_details_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ReceiveDetailQrCodeScreen extends StatelessWidget {
  final ReceiveDetails details;

  const ReceiveDetailQrCodeScreen(this.details, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => ReceiveDetailsBloc(details),
      child: BlocConsumer<ReceiveDetailsBloc, ReceiveDetailsState>(
        listenWhen: (_, current) => current.receivePaidTransaction != null,
        listener: (context, state) {
          // TODO(raul): close this screen and show success dialog
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(context.loc.transferReceiveScanQRCode)),
            body: SafeArea(
              minimum: const EdgeInsets.all(horizontalEdgePadding),
              child: Stack(
                children: [
                  Container(
                    height: size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          QrCodeGeneratorWidget(data: state.details.invoiceLink, size: size.width * 0.8),
                          const SizedBox(height: 20),
                          ShareLinkRow(
                            label: context.loc.transferReceiveShareLink,
                            link: state.details.invoiceLinkUri == null
                                ? state.details.invoiceLink
                                : state.details.invoiceLinkUri.toString(),
                          ),
                          const SizedBox(height: 4),
                          const DividerJungle(height: 6),
                          const SizedBox(height: 16),
                          BalanceRow(
                            label: context.loc.transferReceiveBalanceTotal,
                            fiatAmount: state.details.fiatAmount,
                            tokenAmount: state.details.tokenAmount,
                          ),
                          const SizedBox(height: 4),
                          const DividerJungle(thickness: 2.0, height: 10),
                          const SizedBox(height: 4),
                          if (state.details.memo != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: context.loc.transferReceiveMemo,
                                    children: [TextSpan(text: state.details.memo)]),
                              ),
                            ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButtonLong(
                        title: context.loc.transferReceiveDoneButtonTitle,
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
