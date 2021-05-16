import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class TriStateClipboardIconButton extends StatelessWidget {
  const TriStateClipboardIconButton({
    required this.onClear,
    required this.onPaste,
    required this.isChecked,
    required this.canClear,
  });

  final VoidCallback onClear;
  final VoidCallback onPaste;
  final bool isChecked;
  final bool canClear;

  @override
  Widget build(BuildContext context) {
    if (isChecked) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.green,
      );
    } else if (canClear) {
      return IconButton(
        icon: const Icon(
          Icons.close,
          color: AppColors.grey,
        ),
        onPressed: onClear,
      );
    } else {
      return IconButton(
        icon: const Icon(
          Icons.paste,
          color: AppColors.grey,
        ),
        onPressed: onPaste,
      );
    }
  }
}
