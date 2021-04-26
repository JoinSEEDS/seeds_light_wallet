import 'package:flutter/material.dart';
import 'package:seeds/v2/components/search_user/components/search_result_row.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

class SearchUsersList extends StatelessWidget {
  final List<MemberModel> users;
  final ValueSetter<MemberModel> resultCallBack;

  const SearchUsersList({Key? key, required this.users, required this.resultCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            MemberModel user = users[index];
            return GestureDetector(
              onTap: () {
                resultCallBack(user);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SearchResultRow(
                  account: user.account,
                  name: user.nickname,
                  imageUrl: user.image,
                ),
              ),
            );
          }),
    );
  }
}
