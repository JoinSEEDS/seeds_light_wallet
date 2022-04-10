import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/utils/build_context_extension.dart';

class GenericRegionDialog extends StatelessWidget {
  final String title;
  final String description;

  const GenericRegionDialog({Key? key, required this.title, required this.description}) : super(key: key);

  Future<bool?> show(BuildContext context) async {
    return showDialog(barrierDismissible: false, context: context, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
      leftButtonTitle: context.loc.genericCancelButtonTitle,
      rightButtonTitle: context.loc.genericRegionConfirmImSureButton,
      onRightButtonPressed: () => Navigator.of(context).pop(true),
      children: [
        Text(title, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 40.0),
        Text(description, style: Theme.of(context).textTheme.subtitle2),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
