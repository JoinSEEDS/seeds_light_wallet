import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TransactionAvatar extends StatelessWidget {
  final String? image;
  final String? nickname;
  final String? account;
  final double? size;
  final BoxDecoration? decoration;

  const TransactionAvatar({Key? key, this.image, this.nickname, this.account, this.size, this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildTransactionAvatar(),
    );
  }

  Widget _buildTransactionAvatar() {
    if (image!.startsWith('http')) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: size,
            height: size,
            decoration: decoration,
            child: CachedNetworkImage(imageUrl: image!, fit: BoxFit.cover),
          ));
    } else if (image!.endsWith('.svg')) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: size,
            height: size,
            decoration: decoration != null ? decoration!.copyWith(color: Colors.white) : null,
            child: SvgPicture.asset(image!, fit: BoxFit.scaleDown),
          ));
    } else {
      var shortName = nickname!.isNotEmpty && nickname != 'Seeds Account' && nickname != 'Telos Account'
          ? nickname!.substring(0, 2).toUpperCase()
          : account!.substring(0, 2).toUpperCase();

      return ClipRRect(
        borderRadius: BorderRadius.circular(size!),
        child: Container(
          width: size,
          height: size,
          decoration: decoration,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              shortName,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }
  }
}
