import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/search_user/components/search_user_text_field.dart';
import 'package:seeds/components/search_user/interactor/viewmodels/search_user_bloc.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/domain-shared/user_citizenship_status.dart';

class SearchUser extends StatelessWidget {
  final String? title;
  final List<String>? noShowUsers;
  final UserCitizenshipStatus? filterByCitizenshipStatus;
  final ValueSetter<MemberModel> onUserSelected;

  const SearchUser({
    Key? key,
    this.title,
    this.noShowUsers,
    this.filterByCitizenshipStatus,
    required this.onUserSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocProvider<SearchUserBloc>(
      create: (_) => SearchUserBloc(noShowUsers, filterByCitizenshipStatus),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: SearchUserTextField(),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(title!, style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          BlocBuilder<SearchUserBloc, SearchUserState>(
            builder: (_, state) {
              switch (state.pageState) {
                case PageState.loading:
                case PageState.failure:
                case PageState.success:
                  if (state.pageState == PageState.success && state.users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text(localization.searchUserNoUserFound)),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (_, index) {
                          final MemberModel user = state.users[index];
                          return SearchResultRow(
                            key: Key(user.account),
                            member: user,
                            onTap: () => onUserSelected(user),
                          );
                        },
                      ),
                    );
                  }
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
