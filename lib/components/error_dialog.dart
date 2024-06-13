import 'package:flutter/material.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/images/explore/red_exclamation_circle.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String details;
  final VoidCallback? onRightButtonPressed;

  const ErrorDialog(
      {super.key,
      required this.title,
      required this.details,
      this.onRightButtonPressed});

  Future<void> show(BuildContext context) {
    return showDialog<void>(
        context: context, barrierDismissible: false, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: const CustomPaint(
          size: Size(60, 60), painter: RedExclamationCircle()),
      rightButtonTitle: 'Retry',
      onRightButtonPressed: () {
        Navigator.of(context).pop();
        onRightButtonPressed?.call();
      },
      leftButtonTitle: context.loc.genericCancelButtonTitle,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 20.0),
        Text(details, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
