import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

/// A wigdeg wrapper of TextFormField customized for general inputs
///
class TextFormFieldLightCustom extends StatelessWidget {
  final bool autofocus;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final ValueChanged<String> onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  final FormFieldValidator<String> validator;
  final Widget suffixIcon;
  final String hintText;
  final String labelText;
  final bool disabledLabelColor;

  const TextFormFieldLightCustom({
    Key key,
    this.autofocus = false,
    this.focusNode,
    this.nextFocus,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.enabled,
    this.validator,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.disabledLabelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        autofocus: autofocus,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        controller: controller,
        onChanged: onChanged,
        maxLength: maxLength,
        maxLines: maxLines,
        enabled: enabled,
        validator: validator,
        style: Theme.of(context).textTheme.subtitle2Black,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: AppColors.canopy, width: 1.0)),
          counterText: "",
          hintText: hintText,
          labelText: labelText,
          errorMaxLines: 2,
          errorStyle: const TextStyle(color: Colors.red, wordSpacing: 4.0),
          labelStyle: Theme.of(context).textTheme.subtitle2Black,
          hintStyle: Theme.of(context).textTheme.subtitle2OpacityEmphasisBlack,
          contentPadding: const EdgeInsets.all(16.0),
          enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.black, width: 1.0)),
          errorBorder: OutlineInputBorder(  borderRadius: BorderRadius.circular(8),borderSide: const BorderSide(color: AppColors.red, width: 1.0)),
        ),
      ),
    );
  }
}
