import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/flat_button_long_outlined.dart';
import 'package:seeds/design/app_colors.dart';

const double _padding = 20;
const double _avatarRadius = 40;

/// A custom dialog with top icon that can be used in multiple screens
class CustomDialog extends StatelessWidget {
  /// Top icon dialog
  final Widget? icon;
  final double? iconPadding;

  /// Dialog body content
  final List<Widget> children;

  /// Default title empty
  final String leftButtonTitle;

  /// Require define leftButtonTitle
  final VoidCallback? onLeftButtonPressed;

  /// Default title empty
  final String rightButtonTitle;

  /// Require define rightButtonTitle
  final VoidCallback? onRightButtonPressed;

  /// Default title empty
  final String singleLargeButtonTitle;

  /// Default Navigator pop
  final VoidCallback? onSingleLargeButtonPressed;

  const CustomDialog({
    super.key,
    this.icon,
    required this.children,
    this.leftButtonTitle = '',
    this.onLeftButtonPressed,
    this.rightButtonTitle = '',
    this.onRightButtonPressed,
    this.singleLargeButtonTitle = '',
    this.onSingleLargeButtonPressed,
    this.iconPadding,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  left: _padding, top: _avatarRadius + _padding - 10, right: _padding, bottom: _padding + 10),
              margin: const EdgeInsets.only(top: _avatarRadius),
              decoration: BoxDecoration(
                color: AppColors.tagGreen3,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: const [BoxShadow(offset: Offset(0, 10), blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                  if (leftButtonTitle.isNotEmpty || rightButtonTitle.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              if (leftButtonTitle.isNotEmpty)
                                Expanded(
                                  child: FlatButtonLongOutlined(
                                    title: leftButtonTitle,
                                    onPressed: onLeftButtonPressed ?? () => Navigator.pop(context),
                                  ),
                                ),
                              if (leftButtonTitle.isNotEmpty) const SizedBox(width: 10),
                              if (rightButtonTitle.isNotEmpty)
                                Expanded(
                                  child: FlatButtonLong(
                                    title: rightButtonTitle,
                                    onPressed: onRightButtonPressed,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (/*leftButtonTitle.isEmpty && rightButtonTitle.isEmpty && */singleLargeButtonTitle.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FlatButtonLong(
                            title: singleLargeButtonTitle,
                            onPressed: 
                              onSingleLargeButtonPressed ?? () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (icon != null)
              Positioned(
                left: _padding,
                right: _padding,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: _avatarRadius,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green1.withOpacity(0.20),
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(_avatarRadius)),
                      child: Padding(
                        padding: EdgeInsets.all(iconPadding ?? 8.0),
                        child: icon,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
