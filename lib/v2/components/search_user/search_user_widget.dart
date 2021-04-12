import 'package:flutter/material.dart';
import 'package:seeds/v2/components/user_row_widget.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

/// SearchUserWidget
class SearchUserWidget extends StatelessWidget {
  final ValueSetter<MemberModel> resultCallBack;

  const SearchUserWidget({Key key, @required this.resultCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              hintText: 'Search...',
            ),
            onChanged: (String text) {
              print("First text field: $text");
            },
          ),
        ),
        ListView(
          children: [
            UserRowWidget(
              imageUrl: "",
              account: "theremotecub",
              toOrFromText: null,
              name: "Gery G",
            )
          ],
        )
      ],
    );
  }
}
