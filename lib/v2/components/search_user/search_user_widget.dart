import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/search_user/components/search_result_list.dart';
import 'package:seeds/v2/components/search_user/interactor/search_user_bloc.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_events.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SearchUserWidget extends StatelessWidget {
  final ValueSetter<MemberModel> resultCallBack;
  final _controller = TextEditingController();
  final _searchBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.darkGreen2, width: 2.0),
  );

  SearchUserWidget({Key? key, required this.resultCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchUserBloc>(
      create: (context) => SearchUserBloc(),
      child: BlocBuilder<SearchUserBloc, SearchUserState>(
        builder: (context, SearchUserState state) {
          return Column(
            children: [
              TextField(
                controller: _controller,
                onChanged: (String value) {
                  BlocProvider.of<SearchUserBloc>(context).add(OnSearchChange(searchQuery: value));
                },
                decoration: InputDecoration(
                    prefixIcon: state.pageState == PageState.loading
                        ? Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.green)),
                          )
                        : const SizedBox.shrink(),
                    suffixIcon: IconButton(
                        icon: Icon(
                          state.searchBarIcon,
                          color: AppColors.green,
                          size: 26,
                        ),
                        onPressed: () {
                          if (state.searchBarIcon == Icons.clear) {
                            BlocProvider.of<SearchUserBloc>(context).add(ClearIconTapped());
                            _controller.clear();
                          }
                        }),
                    enabledBorder: _searchBorder,
                    focusedBorder: _searchBorder,
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Search...'),
              ),
              searchResults(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget searchResults(BuildContext context, SearchUserState state) {
    switch (state.pageState) {
      case PageState.initial:
        return const SizedBox.shrink();
      case PageState.loading:
        return SearchUsersList(users: state.users);
      case PageState.failure:
        return SearchUsersList(users: state.users);
      case PageState.success:
        if (state.users.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text("No users found.")),
          );
        } else {
          return SearchUsersList(users: state.users);
        }
    }
  }
}
