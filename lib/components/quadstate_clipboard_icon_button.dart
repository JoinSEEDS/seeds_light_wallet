import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class QuadStateClipboardIconButton extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback? onPaste;
  final bool isChecked;
  final bool canClear;
  final bool isLoading;

  const QuadStateClipboardIconButton({
    super.key,
    required this.onClear,
    this.onPaste,
    required this.isChecked,
    required this.canClear,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(12),
        width: 24,
        height: 24,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.green1),
          strokeWidth: 3,
        ),
      );
    }

    if (isChecked) {
      return const Icon(Icons.check_circle, color: AppColors.green);
    }

    if (canClear) {
      return IconButton(
        icon: const Icon(Icons.close, color: AppColors.grey),
        onPressed: onClear,
      );
    }

    if (onPaste != null) {
      return IconButton(
        icon: const Icon(Icons.paste, color: AppColors.grey),
        onPressed: onPaste,
      );
    }

    return Container(width: 24, height: 24);
  }
}
