import 'package:flutter/material.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/copy_link_row.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/qr_code_generator_widget.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

import 'interactor/viewmodels/receive_detail_arguments.dart';

class ReceiveDetailQrCodeScreen extends StatelessWidget {
  final ReceiveDetailArguments arguments;

  const ReceiveDetailQrCodeScreen(this.arguments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: const Text("Scan QR Code")),
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
                      label: 'Share Link to Invoice',
                      link: arguments.invoiceLink,
                    ),
                    const SizedBox(height: 4),
                    const DividerJungle(
                      height: 6,
                    ),
                    const SizedBox(height: 16),
                    BalanceRow(
                      label: "Total",
                      fiatAmount: arguments.receiveTotalFiat,
                      seedsAmount: arguments.receiveTotalSeeds,
                    ),
                    const SizedBox(height: 4),
                    const DividerJungle(
                      thickness: 2.0,
                      height: 10,
                    ),
                    const SizedBox(height: 4),
                    if (arguments.description != null)
                      Align(alignment: Alignment.centerLeft, child: Text('Memo: ' '${arguments.description!}'))
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
                  title: 'Done',
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
