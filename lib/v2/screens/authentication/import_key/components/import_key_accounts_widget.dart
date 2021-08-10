import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/import_key_bloc.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/viewmodels/import_key_state.dart';

class ImportKeyAccountsWidget extends StatelessWidget {
  const ImportKeyAccountsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportKeyBloc, ImportKeyState>(
      builder: (BuildContext context, ImportKeyState state) {
        switch (state.pageState) {
          case PageState.initial:
            return const SizedBox.shrink();
          case PageState.success:
            return ListView(
                children: state.accounts
                    .map((ProfileModel? profile) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(defaultCardBorderRadius),
                            onTap: () {
                              context.read<ImportKeyBloc>().add(AccountSelected(account: profile!.account));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen2,
                                borderRadius: BorderRadius.circular(defaultCardBorderRadius),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 8),
                                child: ListTile(
                                  leading: ProfileAvatar(
                                    size: 60,
                                    image: profile!.image,
                                    account: profile.account,
                                    nickname: profile.nickname,
                                  ),
                                  title: Text(
                                    profile.nickname ?? '',
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  subtitle: Text(
                                    profile.account,
                                    style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                                  ),
                                  trailing: const Icon(Icons.navigate_next),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList());
          case PageState.loading:
            return const FullPageLoadingIndicator();
          case PageState.failure:
            return FullPageErrorIndicator(
              errorMessage: state.errorMessage,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
