import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

/// PROFILE AVATAR
///
/// This class works with http, svg images or just returns a short name
/// with a colored background
class ProfileAvatar extends StatelessWidget {
  final double size;
  final String image;
  final String nickname;
  final String account;

  const ProfileAvatar({
    @required this.size,
    @required this.image,
    @required this.nickname,
    @required this.account,
  })  : assert(size != null),
        assert(image != null),
        assert(nickname != null),
        assert(account != null);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: size,
        height: size,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (image.startsWith('http')) {
      return CachedNetworkImage(imageUrl: image, fit: BoxFit.cover);
    } else if (image.endsWith('.svg')) {
      return SvgPicture.asset(image, fit: BoxFit.scaleDown);
    } else {
      var shortName = nickname.isNotEmpty && nickname != 'Seeds Account' && nickname != 'Telos Account'
          ? nickname.substring(0, 2).toUpperCase()
          : account.substring(0, 2).toUpperCase();

      return Container(
        color: AppColors.getColorByString(shortName),
        alignment: Alignment.center,
        child: Text(shortName, style: Theme.of(context).textTheme.subtitle1HighEmphasis),
      );
    }
  }
}
