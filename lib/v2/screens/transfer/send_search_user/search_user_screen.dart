import 'package:flutter/material.dart';
import 'package:seeds/v2/components/search_user/search_user_widget.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

/// SearchUser SCREEN
class SearchUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SearchUserWidget(resultCallBack: onUserSelected),
    );
  }

  void onUserSelected(MemberModel memberModel) {}
}
