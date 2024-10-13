import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

/// A widget wrapper of TextFormField customized for general inputs
///
class TextFormFieldLight extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final String? initialText;

  const TextFormFieldLight({
    super.key,
    this.controller,
    this.onChanged,
    this.maxLength,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.initialText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: initialText,
        maxLength: maxLength,
        controller: controller,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
        decoration: InputDecoration(
          counterText: "",
          suffixIcon: suffixIcon,
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.darkGreen3)),
          hintText: hintText,
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
          hintStyle: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.darkGreen3)),
        ),
      ),
    );
  }
}
