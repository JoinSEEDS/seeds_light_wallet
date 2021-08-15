import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/i18n/components/components.i18n.dart';

class FullPageErrorIndicator extends StatelessWidget {
  final String? errorMessage;

  const FullPageErrorIndicator({this.errorMessage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMessage ?? "Oops, Something Went Wrong".i18n,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: AppColors.red1),
      ),
    );
  }
}
