import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wigget wrapper of TextFormField customized
class TextFormFieldCustom extends StatelessWidget {
  final bool autofocus;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final ValueChanged<String> onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  final FormFieldValidator<String> validator;
  final String hintText;
  final String labelText;
  final bool disabledLabelColor;

  const TextFormFieldCustom({
    Key key,
    this.autofocus = false,
    this.focusNode,
    this.nextFocus,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.inputFormatters,
    this.maxLength,
    this.maxLines,
    this.enabled,
    this.validator,
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
        inputFormatters: inputFormatters,
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        enabled: enabled,
        validator: validator,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          counterText: "",
          hintText: hintText,
          labelText: labelText,
          errorMaxLines: 2,
          errorStyle: const TextStyle(
            color: Colors.red,
            wordSpacing: 4.0,
          ),
          labelStyle: Theme.of(context).textTheme.subtitle2,
          hintStyle: const TextStyle(letterSpacing: 1.3),
          contentPadding: const EdgeInsets.only(left: 12, bottom: 15, top: 15, right: 12),
          border: OutlineInputBorder(
            gapPadding: 4,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
