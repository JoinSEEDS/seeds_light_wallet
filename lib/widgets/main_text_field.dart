import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class MainTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final String endText;
  final EdgeInsets margin;
  final int maxLength;
  final Function validator;
  final Function(String) onChanged;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
  final TextInputAction textInputAction;
  final String initialValue;
  final TextStyle counterStyle;
  final TextStyle textStyle;
  final String errorText;
  final Widget suffixIcon;

  final bool autofocus;
  final bool autocorrect;

  MainTextField({
    this.controller,
    this.initialValue,
    this.keyboardType,
    @required this.labelText,
    this.hintText,
    this.endText,
    this.margin,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
    this.autofocus,
    this.counterStyle,
    this.textStyle,
    this.autocorrect = true,
    this.errorText,
    this.suffixIcon,
  });

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText != null ? Container(
            padding: EdgeInsets.only(left: 5, top: 3, bottom: 3),
            child: Text(
              labelText,
              style: TextStyle(color: AppColors.grey),
            ),
          ) : Container(width: 0, height: 0,),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                style: textStyle,
                controller: controller,
                initialValue: initialValue,
                keyboardType: keyboardType,
                autocorrect: autocorrect,
                maxLength: maxLength,
                validator: validator,
                onChanged: (value) => onChanged(value),
                autofocus: autofocus != null ? autofocus : false,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                textInputAction: textInputAction,
                decoration: InputDecoration(
                  suffixIcon: suffixIcon,
                  errorText: errorText,
                  filled: true,
                  fillColor: Colors.white,
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.amberAccent)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: Colors.redAccent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: AppColors.borderGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: AppColors.borderGrey)),
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  counterStyle: counterStyle,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  
                ),
              ),
              endText != null
                  ? Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        endText,
                        style: TextStyle(color: AppColors.grey, fontSize: 16),
                      ),
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
