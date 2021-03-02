import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/components/divider_jungle.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

/// SETTINGS CARD
class SettingsCard extends StatelessWidget {
  /// Card icon
  final IconData icon;

  /// The text title in the first row
  final String title;

  /// The text value next to the title
  final String titleValue;

  /// The descrption text in the second row
  final String descriptionText;

  /// Use if the second row is a widget
  final Widget descriptionWidget;

  final GestureTapCallback onTap;

  const SettingsCard({
    Key key,
    @required this.icon,
    @required this.title,
    this.titleValue = '',
    this.descriptionText = '',
    this.descriptionWidget,
    this.onTap,
  })  : assert(icon != null),
        assert(title != null),
        assert(titleValue != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.greenfield,
            borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(icon),
                  ),
                ],
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.button,
                            ),
                            Text(
                              titleValue,
                              style: Theme.of(context).textTheme.button,
                            ),
                          ],
                        ),
                      ),
                      const DividerJungle(),
                      descriptionWidget != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: descriptionWidget,
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      descriptionText,
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
