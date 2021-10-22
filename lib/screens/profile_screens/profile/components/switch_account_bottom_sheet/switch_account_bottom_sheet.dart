import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/images/profile/add_account_circle.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/viewmodels/switch_account_bloc.dart';

class SwithAccountBottomSheet extends StatelessWidget {
  const SwithAccountBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SwitchAccountBloc(
          BlocProvider.of<AuthenticationBloc>(context), remoteConfigurations.featureFlagExportRecoveryPhraseEnabled)
        ..add(const FindAccountsByKey()),
      child: DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
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
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: state.accounts.length + 1,
                            itemBuilder: (_, index) {
                              if (index == state.accounts.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (state.isRecoverPharseEnabled) {
                                        NavigationService.of(context).navigateTo(Routes.importWords);
                                      } else {
                                        NavigationService.of(context).navigateTo(Routes.importKey);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const CustomPaint(size: Size(60, 60), painter: AddAccountCircle()),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text('Add new account',
                                              style: Theme.of(context).textTheme.buttonHighEmphasis),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: [
                                    ProfileAvatar(
                                      size: 60,
                                      image: state.accounts[index].image,
                                      nickname: state.accounts[index].nickname,
                                      account: state.accounts[index].account,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(state.accounts[index].account,
                                              style: Theme.of(context).textTheme.buttonHighEmphasis),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              state.accounts[index].nickname ?? '',
                                              style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Radio<ProfileModel>(
                                      activeColor: AppColors.green3,
                                      value: state.accounts[index],
                                      groupValue: state.currentAcccout,
                                      onChanged: (value) {
                                        BlocProvider.of<SwitchAccountBloc>(context).add(OnAccountSelected(value!));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (_) => this,
    );
  }
}
