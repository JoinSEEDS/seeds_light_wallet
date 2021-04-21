import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/search_user/interactor/search_user_bloc.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_events.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

class SearchUserWidget extends StatelessWidget {
  final ValueSetter<MemberModel> resultCallBack;

  const SearchUserWidget({Key? key, required this.resultCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchUserBloc>(
      create: (context) => SearchUserBloc(),
      child: BlocBuilder<SearchUserBloc, SearchUserState>(
        builder: (context, SearchUserState state) {
          return Column(
            children: [
              TextField(
                onChanged: (String value) {
                  BlocProvider.of<SearchUserBloc>(context).add(OnSearchChange(searchQuery: value));
                },
                decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Search...'),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(state.users[index].account),
                      );
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}
