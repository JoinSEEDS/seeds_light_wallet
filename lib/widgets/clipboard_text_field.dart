import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/constants/app_colors.dart';

class ClipboardTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  final String labelText;
  final String hintText;

  ClipboardTextField({
    this.controller,
    this.onChanged,
    this.labelText,
    this.hintText = "Paste from clipboard",
  });

  @override
  _ClipboardTextFieldState createState() => _ClipboardTextFieldState();
}

class _ClipboardTextFieldState extends State<ClipboardTextField> {
  bool hasEmptyValue = true;

  void onChanged() {
    if (widget.onChanged != null) widget.onChanged();
  }

  @override
  void initState() {
    widget.controller.addListener(() {
      String val = widget.controller.text;
      if (val == "" && hasEmptyValue == false) {
        setState(() {
          hasEmptyValue = true;
        });
      } else if (val != "" && hasEmptyValue == true) {
        setState(() {
          hasEmptyValue = false;
        });
      }
      onChanged();
    });
    super.initState();
  }

  Widget showPasteButton() {
    return IconButton(
      icon: Icon(Icons.content_paste),
      onPressed: () async {
        ClipboardData clipboardData = await Clipboard.getData('text/plain');
        String clipboardText = clipboardData?.text ?? '';
        widget.controller.text = clipboardText;

        FocusScope.of(context).requestFocus(FocusNode());

        if (widget.controller.text != "") {
          setState(() {
            hasEmptyValue = false;
          });
        }

        onChanged();
      },
    );
  }

  Widget showClearButton() {
    return IconButton(
      icon: Icon(Icons.delete_outline),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            widget.controller.clear();
            onChanged();
          },
        );

        setState(() {
          hasEmptyValue = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
        labelText: widget.labelText,
        suffixIcon: hasEmptyValue ? showPasteButton() : showClearButton(),
        hintText: widget.hintText,
      ),
      style: TextStyle(
        fontFamily: "sfprotext",
      ),
    );
  }
}
