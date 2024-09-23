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
import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/api/balance_repository.dart';
import 'package:seeds/datasource/remote/api/eosaccount_repository.dart';
import 'package:seeds/datasource/remote/api/oswaps_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/eos_account_model.dart';
import 'package:seeds/datasource/remote/model/eos_permissions_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_bloc.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/swap_enter_data_screen.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:seeds/navigation/navigation_service.dart';

class TransferExpert extends StatelessWidget {

  final String walletTokenId;
  final BuildContext outerContext;

  const TransferExpert({
    super.key,
    required this.walletTokenId,
    required this.outerContext,
  });

  void onNextButtonTapped(BuildContext context) async {
    // navigate to basic or expert send_confirmation
    print("Send: Next button pressed");
    final state = BlocProvider.of<TransferExpertBloc>(context).state;
    if (state.deliveryToken == settingsStorage.selectedToken.id) {
      print("proxy token transfer");
      Map<String, ProfileModel> profiles = {};
      profiles["to"] = (await ProfileRepository().getProfile(state.selectedAccounts["to"]!)).asValue?.value
        ?? ProfileModel.usingDefaultValues(account: state.selectedAccounts["to"]!);
      profiles["from"] = (await ProfileRepository().getProfile(state.selectedAccounts["from"]!)).asValue?.value
        ?? ProfileModel.usingDefaultValues(account: state.selectedAccounts["from"]!);
      NavigationService.of(context).navigateTo(Routes.sendEnterData, profiles); // SendEnterDataScreen
    } else {
      // swap mode
      final bal = await BlocProvider.of<TransferExpertBloc>(context)
        .balance(state.selectedAccounts["from"] ?? "", state.sendingToken ?? "");
      BlocProvider.of<TransferExpertBloc>(context).add(const OnOSwapLoad());
      NavigationService.of(context).navigateTo(Routes.sendAbroad, SwapEnterDataArgs(context: context, senderBalance: bal ?? 0)); // SwapEnterDataScreen
    }
    
  }


  @override
  Widget build(BuildContext context) {
    List<String> initialAuthAccounts = [];
    final EOSAccountRepository _accountRepository = EOSAccountRepository();
    return BlocProvider<TransferExpertBloc>(
      lazy: false,
      create: (_) => TransferExpertBloc(null, null),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: Row( children: [
              Text("Delivering"),
              const SizedBox(width: 8),
              TokenSelectField(),
              const SizedBox(width: 8),
              Text("to"),
            ]
            )
            ),
            Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: SelectUserTextField(
                 updater: (s) => { null },
                 accountKey: "to",
                )   
          ),
          Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: Row(
              children: [
                Text("Sending"),
                const SizedBox(width: 8),
                BlocBuilder<TransferExpertBloc, TransferExpertState>(
                  builder: (context, state) => 
                   Text('${state.sendingToken.split("#")[2]} (${state.sendingToken.split("#")[1]})'),
                ),
                const SizedBox(width: 8),
                Text("from"),
              ])
          ),
          Padding(
            padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
            child: Row( children: [
              Expanded (child: 
                SelectUserTextField(initialValue: settingsStorage.accountName,
                  accountKey: "from", 
                )   
              ),
              SizedBox(width: 16),
              BlocBuilder<TransferExpertBloc, TransferExpertState>(
                builder: (context, state) {
                  return SignerSelectField(
                    enabled: state.validChainAccounts.contains("from"), // if user is valid
                    account: state.selectedAccounts["from"],
                  );
                },
              ),
              SizedBox(width: 8),
            ])
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
          BlocBuilder<TransferExpertBloc, TransferExpertState>(
            builder: (context, state) {
            return Align(
            alignment: Alignment.bottomCenter,
            child: FlatButtonLong(
              title: context.loc.transferSendNextButtonTitle,
              enabled: state.validChainAccounts.contains("to")
                && state.validChainAccounts.contains("from"),
              onPressed: () {
                onNextButtonTapped(context);
              },
            ),
          );
            })
        ],
      ),
    );
  }
}
