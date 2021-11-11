import 'package:flutter/material.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/components/delegator_row_widget.dart';

class DelegatorsListWidget extends StatelessWidget {
  final List<MemberModel> delegators;

  const DelegatorsListWidget({Key? key, required this.delegators}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: delegators.map((MemberModel delegator) => DelegatorRowWidget(delegator: delegator)).toList(),
    );
  }
}
