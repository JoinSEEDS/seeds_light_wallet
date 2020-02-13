import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/telos_balance_notifier.dart';

class TelosBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<TelosBalanceNotifier>(
      builder: (ctx, model, child) {
        var quantity = model?.balance?.quantity ?? '0.0000 TLOS';

        return Container(
          width: width,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.blue.withOpacity(0.3)),
          ),
          padding: EdgeInsets.all(7),
          child: Column(
            children: <Widget>[
              Text(
                'Telos balance',
                style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
              Padding(padding: EdgeInsets.only(top: 3)),
              Text(
                '$quantity',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
