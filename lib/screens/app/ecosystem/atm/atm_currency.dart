import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/widgets/main_text_field.dart';

class AtmCurrency extends StatelessWidget {
  
  final String name;
  final String exchangeRate;
  final Color color;

  AtmCurrency({Key key, this.name, this.color, this.exchangeRate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final relativePadding = width * 0.05;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      //padding: EdgeInsets.only(top: 7, bottom: 7, left: 7 + relativePadding, right: 7 + relativePadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              if(exchangeRate != null) Container(
                child: Text(
                  exchangeRate,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 200,
            child: MainTextField(
              keyboardType: TextInputType.number,
              controller: null,
              suffixIcon: Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}