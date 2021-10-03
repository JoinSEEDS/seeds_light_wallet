import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneNumberInternationalFormatter =
    // ignore: unnecessary_raw_strings
    MaskTextInputFormatter(mask: '+# (###) ###-####', filter: {"#": RegExp(r'[0-9]')});
