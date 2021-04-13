

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/widgets.i18n.dart';

class ClipboardTextField extends StatefulWidget {
  final String defaultHintText =  'Paste from clipboard'.i18n;
  final TextEditingController? controller;
  final Function? onChanged;
  final String? labelText;
  final String? hintText;

  ClipboardTextField({
    this.controller,
    this.onChanged,
    this.labelText,
    this.hintText,
  });

  @override
  _ClipboardTextFieldState createState() => _ClipboardTextFieldState();
}

class _ClipboardTextFieldState extends State<ClipboardTextField> {
  bool hasEmptyValue = true;
  String? previousValue;

  void onChanged() {
    if (widget.onChanged != null) widget.onChanged!();
  }

  @override
  void initState() {
    widget.controller!.addListener(() {
      var val = widget.controller!.text;

      if (val == previousValue) {
        return;
      } else {
        previousValue = val;
      }

      if (val == '' && hasEmptyValue == false) {
        setState(() {
          hasEmptyValue = true;
        });
      } else if (val != '' && hasEmptyValue == true) {
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
        var clipboardData = await Clipboard.getData('text/plain');
        var clipboardText = clipboardData?.text ?? '';
        widget.controller!.text = clipboardText;

        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget showClearButton() {
    return IconButton(
      icon: Icon(Icons.delete_outline),
      onPressed: () {
        WidgetsBinding.instance!.addPostFrameCallback(
          (_) {
            widget.controller!.clear();
          },
        );
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
        hintText: widget.hintText != null ? widget.hintText!.i18n : widget.defaultHintText,
      ),
      style: TextStyle(
        fontFamily: 'worksans',
      ),
    );
  }
}
