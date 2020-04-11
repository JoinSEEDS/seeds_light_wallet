import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/widgets/main_text_field.dart';

class AtmCurrency extends StatelessWidget {
  
  final String _text;
  final String _exchangeRate;
  final Color _color;

  AtmCurrency(this._text, {Key key, Color color, String exchangeRate}) :
      _color = color,
      _exchangeRate = exchangeRate,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final relativePadding = width * 0.05;

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _color,
      ),
      padding: EdgeInsets.only(top: 7, bottom: 7, left: 7 + relativePadding, right: 7 + relativePadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              if(_exchangeRate != null) Container(
                child: Text(
                  _exchangeRate,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 40,
            height: 40,
          ),

          SizedBox(
            width: 200,
            child: MainTextField(
              keyboardType: TextInputType.number,
              controller: null,
            ),
          ),

          /*MainTextField(
            keyboardType: TextInputType.number,
            controller: null,
            labelText: 'Transfer amount',
            endText: 'TLOS',
            maxLength: 100,
          ),*/
        ],
      ),
    );
  }
}