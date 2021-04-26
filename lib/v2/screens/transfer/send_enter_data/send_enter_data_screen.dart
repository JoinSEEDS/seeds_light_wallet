import 'package:flutter/material.dart';
import 'package:seeds/v2/components/balance_row.dart';
import 'package:seeds/v2/components/search_user/components/search_result_row.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

/// SendEnterDataScreen SCREEN
class SendEnterDataScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MemberModel memberModel = ModalRoute.of(context)!.settings.arguments! as MemberModel;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
              // BlocProvider.of<SearchUserBloc>(context).add(OnSearchChange(searchQuery: value));
            },
          ),
          Text("USD", style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,),
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
            fiatAmount: "10",
            seedsAmount: "10",
          ),
        ],
      ),
    );
  }
}
