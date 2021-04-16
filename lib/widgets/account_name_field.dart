import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/features/account/account_generator_service.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/create_account.i18n.dart';

enum AccountNameStatus { initial, loading, acceptable, unacceptable }

class AccountNameField extends StatelessWidget {
  final TextEditingController? controller;
  final Function? onChanged;
  final FocusNode? focusNode;
  final String? errorText;
  final Widget? suffixIcon;
  final AccountNameStatus? status;

  const AccountNameField({
    this.controller,
    this.status,
    this.onChanged,
    this.focusNode,
    this.errorText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final errorString = validate(controller!.text);
    final valid = errorString;

    var suffixIcon;
    switch (status) {
      case AccountNameStatus.loading:
        suffixIcon = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
          ],
        );
        break;
      case AccountNameStatus.acceptable:
        suffixIcon = const Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
          size: 24.0,
        );
        break;
      case AccountNameStatus.unacceptable:
        suffixIcon = const Icon(
          Icons.remove_circle,
          color: Colors.redAccent,
          size: 24.0,
        );
        break;
      case AccountNameStatus.initial:
        suffixIcon = Container(
          width: 1,
          color: Colors.transparent,
        );
        break;
      default:
        suffixIcon = const SizedBox.shrink();
    }

    return MainTextField(
      labelText: 'SEEDS Username'.i18n,
      autocorrect: false,
      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400, fontFamily: 'worksans'),
      controller: controller,
      maxLength: 12,
      inputFormatters: [
        LowerCaseTextFormatter(),
      ],
      focusNode: focusNode,
      validator: validator,
      counterStyle: TextStyle(
          color: valid is ValidationResult ? Colors.green : Colors.black45,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'worksans'),
      onChanged: onChanged as dynamic Function(String)?,
      errorText: errorText,
      suffixIcon: suffixIcon,
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
