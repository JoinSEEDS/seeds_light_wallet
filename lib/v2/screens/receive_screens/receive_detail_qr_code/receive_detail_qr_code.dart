import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/copy_link_row_light.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/i18n/explore_screens/invite/invite.i18n.dart';
import 'interactor/viewmodels/receive_detail_arguments.dart';

class ReceiveDetailQrCodeScreen extends StatelessWidget {
  final ReceiveDetailArguments arguments;

  const ReceiveDetailQrCodeScreen(this.arguments);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                    QrImage(
                      data: arguments.InvoiceLink,
                      size: width * 0.8,
                      foregroundColor: AppColors.black,
                      errorStateBuilder: (_, err) {
                        return Container(
                          child: Center(
                            child: Text('Uh oh! Something went wrong...'.i18n, textAlign: TextAlign.center),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ShareLinkRowLight(
                      label: 'Share Link to Invoice',
                      link: arguments.InvoiceLink,
                    ),
                    const SizedBox(height: 4),
                    const DividerJungle(
                      height: 6,
                    ),
                    const SizedBox(height: 16),
                     BalanceRow(
                      label: "Total",
                      fiatAmount: arguments.ReceiveTotalFiat,
                      seedsAmount: arguments.ReceiveTotalSeeds,
                    ),
                    const SizedBox(height: 4),
                    const DividerJungle(
                      thickness: 2.0,
                      height: 10,
                    ),
                    const SizedBox(height: 4),
                    arguments.description != null
                        ? Align(alignment: Alignment.centerLeft, child: Text("Description: " + arguments.description!))
                        : const SizedBox.shrink(),
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
                  enabled: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
