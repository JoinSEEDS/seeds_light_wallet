import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/search_result_row.dart';
import 'package:seeds/components/transfer_expert/components/select_user_text_field.dart';
import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/components/transfer_expert/signer_select_field.dart';
import 'package:seeds/components/transfer_expert/token_select_field.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class TransferExpert extends StatelessWidget {

  final String walletTokenId;

  const TransferExpert({
    super.key,
    required this.walletTokenId
  });

  void onNextButtonTapped() {
    // navigate to basic or expert send_confirmation
    print("Send: Next button pressed");
  }

  ///void updateText(BuildContext context, String key, String text) {
  //  BlocProvider.of<TransferExpertBloc>(context).add(OnSearchChange(searchQuery: text.toLowerCase(), accountKey: key));
  //}

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransferExpertBloc>(
      create: (_) => TransferExpertBloc(null, null),
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
            child: Row( children: [
              Expanded (child: 
                SelectUserTextField(initialValue: settingsStorage.accountName,
                 updater: (s) => 
                   BlocProvider.of<TransferExpertBloc>(context)
                     .add(OnSearchChange(searchQuery: s.toLowerCase(), accountKey: "from"))
                )   
              ),
              SizedBox(width: 16),
              SignerSelectField(
                enabled: true, // if user is valid
                account: 'chuckseattle' // state.transfer_fro
              ),
                SizedBox(width: 8),
            ])
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
            Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: SelectUserTextField(initialValue: settingsStorage.accountName,
                 updater: (s) => 
                   BlocProvider.of<TransferExpertBloc>(context)
                     .add(OnSearchChange(searchQuery: s.toLowerCase(), accountKey: "from"))
                )   
     ),
          const SizedBox(height: 16),
          /*
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
          */
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButtonLong(
              title: context.loc.transferSendNextButtonTitle,
              enabled: true, //state.isNextButtonEnabled,
              onPressed: () {
                onNextButtonTapped();
              },
            ),
          )

        ],
      ),
    );
  }
}
