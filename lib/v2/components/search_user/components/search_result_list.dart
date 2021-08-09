import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/search_result_row.dart';
import 'package:seeds/v2/components/search_user/interactor/search_user_bloc.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

class SearchUsersList extends StatelessWidget {
  final ValueSetter<MemberModel> resultCallBack;

  const SearchUsersList({Key? key, required this.resultCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserBloc, SearchUserState>(builder: (context, SearchUserState state) {
      return Expanded(
        child: ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (BuildContext context, int index) {
              MemberModel user = state.users[index];
              return SearchResultRow(
                key: Key(user.account),
                account: user.account,
                name: user.nickname,
                imageUrl: user.image,
                resultCallBack: (){
                  resultCallBack(user);
                },
              );
            }),
      );
    });
  }
}
