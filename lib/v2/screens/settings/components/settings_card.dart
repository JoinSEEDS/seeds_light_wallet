import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';

/// SETTINGS CARD
class SettingsCard extends StatelessWidget {
  /// Card icon
  final IconData icon;

  /// The text title in the first row
  final String title;

  /// The text value next to the title
  final String titleValue;

  /// To set a different color to titleValue
  final Color titleValueColor;

  /// The descrption text in the second row
  final String descriptionText;

  /// Use if the second row is a widget
  final Widget descriptionWidget;

  /// Route to which the card navigates.
  final String route;

  const SettingsCard({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.titleValue,
    this.titleValueColor,
    this.descriptionText = '',
    this.descriptionWidget,
    this.route,
  })  : assert(icon != null),
        assert(title != null),
        assert(titleValue != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => NavigationService.of(context).navigateTo(route),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.greenfield,
            borderRadius: BorderRadius.circular(12.0),
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
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              titleValue,
                              style: titleValueColor != null
                                  ? Theme.of(context).textTheme.subtitle1.copyWith(color: titleValueColor)
                                  : Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.jungle, thickness: 1, height: 1),
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
