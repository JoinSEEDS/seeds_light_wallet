import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/shimmer_circle.dart';
import 'package:seeds/components/shimmer_rectangle.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';
import 'package:seeds/utils/text_size_extension.dart';

class ProfileListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String trailing;
  final VoidCallback onTap;

  const ProfileListTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final Text titleText = Text(title, style: Theme.of(context).textTheme.button);
        final Text trailingText = Text(trailing, style: Theme.of(context).textTheme.headline7LowEmphasis);
        return state.showShimmer
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Row(
                  children: [
                    const ShimmerCircle(28),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Row(
                        children: [
                          ShimmerRectangle(size: titleText.textSize),
                          const Spacer(),
                          const ShimmerRectangle(size: Size(52, 21)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                  child: Row(children: [leading, const SizedBox(width: 20), Expanded(child: titleText), trailingText]),
                ),
              );
      },
    );
  }
}
