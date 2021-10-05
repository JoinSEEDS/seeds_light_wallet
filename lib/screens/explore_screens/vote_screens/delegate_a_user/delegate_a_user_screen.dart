import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/delegate_a_user_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_events.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_state.dart';

class DelegateAUserScreen extends StatelessWidget {
  const DelegateAUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DelegateAUserBloc(),
      child: BlocListener<DelegateAUserBloc, DelegateAUserState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          BlocProvider.of<DelegateAUserBloc>(context).add(ClearPageCommand());
        },
        child: BlocBuilder<DelegateAUserBloc, DelegateAUserState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(title: const Text("Delegate A User")),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SearchUser(
                            title: "Citizens",
                            resultCallBack: (selectedUser) {
                              BlocProvider.of<DelegateAUserBloc>(context).add(OnUserSelected(selectedUser));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
