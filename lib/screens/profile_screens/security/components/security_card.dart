import 'package:flutter/material.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/notification_badge.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

/// SECURITY CARD
class SecurityCard extends StatelessWidget {
  /// Card icon
  final Widget icon;

  /// The text title in the first row
  final String title;

  /// The description text in the second row
  final String description;

  /// The widget in the right side of the title
  final Widget? titleWidget;

  final GestureTapCallback? onTap;

  final bool hasNotification;

  const SecurityCard(
      {super.key,
      required this.icon,
      required this.title,
      this.description = '',
      this.titleWidget,
      this.onTap,
      this.hasNotification = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.darkGreen2,
            borderRadius: BorderRadius.circular(defaultCardBorderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 8.0),
                    child: icon,
                  ),
                ],
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      title,
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (hasNotification) const NotificationBadge()
                                ],
                              ),
                            ),
                          ),
                          if (titleWidget != null) titleWidget!,
                        ],
                      ),
                      const DividerJungle(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(description, style: Theme.of(context).textTheme.subtitle3),
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
