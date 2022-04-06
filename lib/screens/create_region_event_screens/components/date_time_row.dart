import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class DateTimeRow extends StatelessWidget {
  final VoidCallback? onWidgetTapped;
  final String label;
  final String timeInfo;
  final Widget icon;

  const DateTimeRow({
    Key? key,
    required this.label,
    required this.timeInfo,
    required this.onWidgetTapped,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      color: AppColors.darkGreen3,
      child: InkWell(
        borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        onTap: onWidgetTapped,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              const SizedBox(width: 20),
              icon,
              const SizedBox(width: 20),
              if (timeInfo.isNotEmpty)
                Text(timeInfo, style: Theme.of(context).textTheme.headline7)
              else
                Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline7),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
