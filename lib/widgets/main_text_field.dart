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
  final Image suffixIcon;

  MainTextField({
    this.controller,
    this.keyboardType,
    @required this.labelText,
    this.hintText,
    this.endText,
    this.margin,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.suffixIcon,
  });

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(labelText != null) Container(
            padding: EdgeInsets.only(left: 5, top: 3, bottom: 3),
            child: Text(
              labelText,
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                maxLength: maxLength,
                validator: validator,
                onChanged: (value) => onChanged(value),
                focusNode: focusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  errorBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: AppColors.borderGrey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: AppColors.borderGrey)),
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  suffixIcon: suffixIcon,
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
