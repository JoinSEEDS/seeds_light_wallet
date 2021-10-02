import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/images/profile/add_account_circle.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/viewmodels/switch_account_bloc.dart';

class SwithAccountBottomSheet extends StatelessWidget {
  const SwithAccountBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SwitchAccountBloc(BlocProvider.of<AuthenticationBloc>(context))..add(const FindAccountsByKey()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 22.0),
              width: 54,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const DividerJungle(thickness: 4, height: 4),
              ),
            ),
            BlocConsumer<SwitchAccountBloc, SwitchAccountState>(
              listenWhen: (_, current) => current.pageState == PageState.failure,
              listener: (context, state) {
                Navigator.of(context).pop();
                SnackBarInfo(state.errorMessage ?? '', ScaffoldMessenger.of(context)).show();
              },
              builder: (context, state) {
                switch (state.pageState) {
                  case PageState.loading:
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  case PageState.success:
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        for (var i in state.accounts)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                ProfileAvatar(
                                  size: 60,
                                  image: i.image,
                                  nickname: i.nickname,
                                  account: i.account,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(i.account, style: Theme.of(context).textTheme.buttonHighEmphasis),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          i.nickname ?? '',
                                          style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Radio<ProfileModel>(
                                  activeColor: AppColors.green3,
                                  value: i,
                                  groupValue: state.currentAcccout,
                                  onChanged: (value) {
                                    BlocProvider.of<SwitchAccountBloc>(context).add(OnAccountSelected(value!));
                                  },
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                const CustomPaint(size: Size(60, 60), painter: AddAccountCircle()),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text('Add new account', style: Theme.of(context).textTheme.buttonHighEmphasis),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      context: context,
      builder: (_) => this,
    );
  }
}
