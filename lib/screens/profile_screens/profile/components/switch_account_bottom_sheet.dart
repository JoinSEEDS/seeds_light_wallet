import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/bloc.dart';

class SwithAccountBottomSheet extends StatelessWidget {
  const SwithAccountBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 22.0),
                width: 54,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const DividerJungle(thickness: 4, height: 4),
                ),
              ),
              Row(
                children: [
                  ProfileAvatar(
                    size: 60,
                    image: state.profile!.image,
                    nickname: state.profile!.nickname,
                    account: state.profile!.account,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.profile!.account, style: Theme.of(context).textTheme.buttonHighEmphasis),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            state.profile?.nickname ?? '',
                            style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                          ),
                        )
                      ],
                    ),
                  ),
                  Radio<String>(
                    activeColor: AppColors.green3,
                    value: '',
                    groupValue: '',
                    onChanged: (value) {},
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
