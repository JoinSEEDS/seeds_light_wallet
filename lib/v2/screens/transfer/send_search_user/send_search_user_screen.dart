import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/search_user/search_user_widget.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/screens/transfer/send_search_user/interactor/send_search_user_bloc.dart';
import 'package:seeds/v2/screens/transfer/send_search_user/interactor/viewmodels/send_search_user_state.dart';

/// SendScannerScreen SCREEN
class SendSearchUserScreen extends StatefulWidget {
  @override
  _SendSearchUserScreenState createState() => _SendSearchUserScreenState();
}

class _SendSearchUserScreenState extends State<SendSearchUserScreen> {
  late SearchUserWidget _searchUserWidget;
  final _sendSearchUserPageBloc = SendSearchUserPageBloc();

  @override
  void initState() {
    super.initState();
    _searchUserWidget = SearchUserWidget(resultCallBack: onResult);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SendSearchUserPageBloc>(
        create: (_) => _sendSearchUserPageBloc,
        child: BlocBuilder<SendSearchUserPageBloc, SendSearchUserPageState>(
          builder: (context, SendSearchUserPageState state) {
            return Scaffold(
              appBar: AppBar(title: const Text("Send")),
              body: _searchUserWidget,
            );
          },
        ));
  }

  Future<void> onResult(MemberModel scanResult) async {
    // _sendSearchUserPageBloc.add(ExecuteScanResult(scanResult: scanResult));
  }
}
