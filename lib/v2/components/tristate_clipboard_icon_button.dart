import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';

class TriStateClipboardIconButton extends StatelessWidget {
  const TriStateClipboardIconButton({
    required this.onClear,
    required this.onPaste,
    required this.isChecked,
    required this.canClear,
    required this.isLoading,
  });

  final VoidCallback onClear;
  final VoidCallback onPaste;
  final bool isChecked;
  final bool canClear;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.green1),
          strokeWidth: 3,
        ),
        width: 24,
        height: 24,
      );
    }

    if (isChecked) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.green,
      );
    }

    if (canClear) {
      return IconButton(
        icon: const Icon(
          Icons.close,
          color: AppColors.grey,
        ),
        onPressed: onClear,
      );
    }

    return IconButton(
      icon: const Icon(
        Icons.paste,
        color: AppColors.grey,
      ),
      onPressed: onPaste,
    );
  }
}
