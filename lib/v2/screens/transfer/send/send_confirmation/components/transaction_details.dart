import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';

class TransactionDetails extends StatelessWidget {
  final Widget? image;
  final String? title;
  final String? beneficiary;

  const TransactionDetails({this.image, this.title, this.beneficiary});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.darkGreen2,
            shape: BoxShape.circle,
          ),
          width: width * 0.28,
          height: width * 0.28,
          child: image,
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Text(
            title!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline8,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
          child: Text(
            beneficiary!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle3,
          ),
        ),
      ],
    );
  }
}
