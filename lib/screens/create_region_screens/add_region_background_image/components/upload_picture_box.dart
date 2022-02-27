import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class UploadPictureBox extends StatelessWidget {
  final String title;
  final String? backgroundImage;
  final VoidCallback onTap;

  const UploadPictureBox({
    Key? key,
    required this.title,
    this.backgroundImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(defaultCardBorderRadius),
        dashPattern: [8, 4],
        strokeWidth: 2,
        color: AppColors.grey,
        child: Ink(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (backgroundImage != null) Image.asset(backgroundImage!),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(title, style: Theme.of(context).textTheme.subtitle2),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
