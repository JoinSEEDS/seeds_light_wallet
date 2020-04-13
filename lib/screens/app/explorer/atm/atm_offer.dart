import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/screens/app/explorer/atm/atm_currency.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

class AtmOffer extends StatelessWidget {
  
  final String name;
  final String exchangeRate;
  final Color color;

  AtmOffer({Key key, this.name, this.color, this.exchangeRate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final relativePadding = width * 0.05;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: AppColors.gradient,
        ),
      ),
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 7 + relativePadding, right: 7 + relativePadding),
      child: Column(
        children: <Widget>[
          AtmCurrency(
            name: "SEEDS",
            color: AppColors.green.withOpacity(0.3),
            exchangeRate: "123",
          ),
          AtmCurrency(
            name: "USD",
            color: AppColors.blue.withOpacity(0.3),
            exchangeRate: "0.123",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 5),
            child: EmptyButton(
              width: width * 0.5,
              title: 'SEEK OFFER',
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}