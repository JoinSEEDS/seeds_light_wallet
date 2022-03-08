import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seeds/components/dotted_border/dotted_border.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

class UploadPictureBox extends StatelessWidget {
  final String title;
  final File? backgroundImage;
  final VoidCallback onTap;

  const UploadPictureBox({
    Key? key,
    required this.title,
    this.backgroundImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.rRect,
        radius: const Radius.circular(defaultCardBorderRadius),
        dashPattern: [8, 4],
        strokeWidth: 2,
        color: AppColors.grey,
        child: Ink(
          height: 200,
          child: Container(
            width: width,
            child: backgroundImage != null
                ? Image.file(backgroundImage!, fit: BoxFit.cover)
                : Stack(
                    alignment: Alignment.center,
                    children: [
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
      ),
    );
  }
}
