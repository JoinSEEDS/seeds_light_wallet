import 'package:flutter/material.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

/// SearchUserWidget
class SearchUserWidget extends StatelessWidget {
  final ValueSetter<MemberModel> resultCallBack;

  const SearchUserWidget({Key key, @required this.resultCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        )
      ],
    );
  }
}
