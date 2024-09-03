import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/search_user/components/search_user_text_field.dart';
import 'package:seeds/components/search_user/interactor/viewmodels/search_user_bloc.dart';
import 'package:seeds/components/transfer_expert/token_select_field.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/utils/build_context_extension.dart';

class TransferExpert extends StatelessWidget {

  final String walletTokenId;

  const TransferExpert({
    super.key,
    required this.walletTokenId
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchUserBloc>(
      create: (_) => SearchUserBloc(null, null),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: Row(
              children: [
                Text("Sending"),
                const SizedBox(width: 8),
                Text('${walletTokenId.split("#")[1]} (${walletTokenId.split("#")[0]})'),
                const SizedBox(width: 8),
                Text("from"),
              ])
          ),
          Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: SearchUserTextField(initialValue: settingsStorage.accountName),
          ),
          const Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: Row( children: [
              Text("Delivering"),
              const SizedBox(width: 8),
              TokenSelectField(),
              const SizedBox(width: 8),
              Text("to"),
            ]
            )),
            const Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: SearchUserTextField(),
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
                      child: Center(child: Text(context.loc.searchUserNoUserFound)),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (_, index) {
                          final ProfileModel user = state.users[index];
                          return SearchResultRow(
                            key: Key(user.account),
                            member: user,
                            //onTap: () => onUserSelected(user),
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
