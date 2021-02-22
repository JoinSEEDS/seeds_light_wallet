

import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/models/models.dart';

extension CircleAvatarFactory on CircleAvatar {

static CircleAvatar buildProductAvatar(ProductModel product, {double size = 20}) {
  return CircleAvatar(
    backgroundImage:
        product.picture.isNotEmpty ? NetworkImage(product.picture) : null,
    child: product.picture.isEmpty
        ? Container(
            color: AppColors.getColorByString(product.name),
            child: Center(
              child: Text(
                product.name == null ? '' : product.name.characters.first,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        : null,
    radius: size,
  );
}

}

