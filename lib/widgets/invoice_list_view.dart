import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

class InvoiceListView extends StatefulWidget {

  final InvoiceModel invoice;

  const InvoiceListView({Key key, @required this.invoice})
      : super(key: key);

  @override
  _InvoiceListViewState createState() => _InvoiceListViewState();
}

class _InvoiceListViewState extends State<InvoiceListView> {
  @override
  Widget build(BuildContext context) {
    var fiat = SettingsNotifier.of(context).selectedFiatCurrency;

    return Consumer<RateNotifier>(
        builder: (context, rateNotifier, child) => Column(
          children: [
            Column(
                children: 
                  List<Widget>.of(widget.invoice.items.map((e) => Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(children: [
                        Expanded(
                          child: Text(e.name,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "worksans")),
                        ),
                        Text(e.quantity.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: "worksans")),
                        Expanded(
                          child: Text(e.totalAmount.seedsFormatted,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "worksans")),
                        ),
                      ]
                      ),
                    ))
                    )

                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 3,
                      height: 24,
                    ),
                    Row(
                      children:
                      [ 
                        Text("Total".i18n,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: "worksans")),
                        Spacer(),
                        Text(widget.invoice.amount,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: "worksans")),
                      ]
                    ),
                    Row(
                      children:
                      [ 
                        Spacer(),
                        Text( rateNotifier.seedsTo(widget.invoice.doubleAmount, fiat).fiatFormatted + " $fiat",
                            style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                fontFamily: "worksans")),
                      ]
                    )
          ],
        )
                );
  }
}