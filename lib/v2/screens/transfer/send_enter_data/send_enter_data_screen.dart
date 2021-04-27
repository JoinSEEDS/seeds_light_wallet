import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/search_user/components/search_result_row.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/send_enter_data_bloc.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_events.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';

/// SendEnterDataScreen SCREEN
class SendEnterDataScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MemberModel memberModel = ModalRoute.of(context)!.settings.arguments! as MemberModel;
    RatesState rates = BlocProvider.of<RatesBloc>(context).state;
    return BlocProvider(
        create: (context) => SendEnterDataPageBloc(memberModel, rates)..add(InitSendDataArguments()),
        child: Scaffold(
          appBar: AppBar(),
          body: BlocBuilder<SendEnterDataPageBloc, SendEnterDataPageState>(
              builder: (context, SendEnterDataPageState state) {
            return Column(
              children: [
                Text(
                  "Send to",
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                SearchResultRow(
                  account: memberModel.account,
                  imageUrl: memberModel.image,
                  name: memberModel.nickname,
                ),
                const SizedBox(height: 36),
                TextFormField(
                  maxLines: 1,
                  controller: _controller,
                  style: Theme.of(context).textTheme.headline4,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "0.0",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  autofocus: true,
                  onChanged: (String value) {
                    BlocProvider.of<SendEnterDataPageBloc>(context).add(OnAmountChange(amountChanged: value));
                  },
                ),
                Text(
                  state.fiatAmount ?? "",
                  style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                ),
                const SizedBox(height: 36),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Add a Note",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintMaxLines: 150,
                  ),
                  autofocus: false,
                  onChanged: (String value) {
                    // BlocProvider.of<SearchUserBloc>(context).add(OnSearchChange(searchQuery: value));
                  },
                ),
                const SizedBox(height: 36),
                BalanceRow(
                  label: "Available Balance",
                  fiatAmount: state.availableBalanceFiat ?? "",
                  seedsAmount: state.availableBalance ?? "",
                ),
              ],
            );
          }),
        ));
  }
}
