import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/search_user/interactor/viewmodels/search_user_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SearchUserTextField extends StatefulWidget {
  const SearchUserTextField({super.key});

  @override
  _SearchUserTextFieldState createState() => _SearchUserTextFieldState();
}

class _SearchUserTextFieldState extends State<SearchUserTextField> {
  final TextEditingController _controller = TextEditingController();
  final _searchBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.darkGreen2, width: 2.0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      autocorrect: false,
      controller: _controller,
      onChanged: (value) {
        BlocProvider.of<SearchUserBloc>(context).add(OnSearchChange(searchQuery: value.toLowerCase()));
      },
      decoration: InputDecoration(
        suffixIcon: BlocBuilder<SearchUserBloc, SearchUserState>(
          builder: (context, state) {
            return state.pageState == PageState.loading
                ? Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.green)),
                  )
                : IconButton(
                    icon: Icon(state.showClearIcon ? Icons.clear : Icons.search, color: AppColors.white, size: 26),
                    onPressed: () {
                      if (state.showClearIcon) {
                        BlocProvider.of<SearchUserBloc>(context).add(const ClearIconTapped());
                        _controller.clear();
                      }
                    },
                  );
          },
        ),
        enabledBorder: _searchBorder,
        focusedBorder: _searchBorder,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: context.loc.searchUserHintText,
      ),
    );
  }
}
