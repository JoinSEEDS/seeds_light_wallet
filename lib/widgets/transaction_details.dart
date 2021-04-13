import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class TransactionDetails extends StatelessWidget {
  final Widget image;
  final String title;
  final String beneficiary;

  TransactionDetails({this.image, this.title, this.beneficiary});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Container(
          width: width * 0.22,
          height: width * 0.22,
          child: image,
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 20, right: 20),
          child: Text(
            beneficiary,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        ),
      ],
    );
  }
}
