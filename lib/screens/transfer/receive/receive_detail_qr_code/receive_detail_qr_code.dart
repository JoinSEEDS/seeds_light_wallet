import 'package:flutter/material.dart';
import 'package:seeds/components/balance_row.dart';
import 'package:seeds/components/copy_link_row.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/qr_code_generator_widget.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/transfer/transfer.i18n.dart';
import 'interactor/viewmodels/receive_detail_arguments.dart';

class ReceiveDetailQrCodeScreen extends StatelessWidget {
  final ReceiveDetailArguments arguments;

  const ReceiveDetailQrCodeScreen(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: Text("Scan QR Code".i18n)),
        body: Stack(
          children: [
            Container(
              height: height,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    QrCodeGeneratorWidget(
                      data: arguments.invoiceLink,
                      size: width * 0.8,
                    ),
                    const SizedBox(height: 20),
                    ShareLinkRow(
                      label: 'Share Link to Invoice'.i18n,
                      link: arguments.invoiceLink,
                    ),
                    const SizedBox(height: 4),
                    const DividerJungle(
                      height: 6,
                    ),
                    const SizedBox(height: 16),
                    BalanceRow(
                      label: "Total".i18n,
                      fiatAmount: arguments.fiatAmount,
                      tokenAmount: arguments.tokenAmount,
                    ),
                    const SizedBox(height: 4),
                    const DividerJungle(
                      thickness: 2.0,
                      height: 10,
                    ),
                    const SizedBox(height: 4),
                    if (arguments.description != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Memo: '.i18n, children: <TextSpan>[TextSpan(text: arguments.description)]),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(horizontalEdgePadding),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButtonLong(
                  title: 'Done'.i18n,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
