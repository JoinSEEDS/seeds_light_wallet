import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/search_user/search_user_widget.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/screens/transfer/send_search_user/interactor/send_search_user_bloc.dart';

/// SendSearchUserScreen SCREEN
class SendSearchUserScreen extends StatefulWidget {
  @override
  _SendSearchUserScreenState createState() => _SendSearchUserScreenState();
}

class _SendSearchUserScreenState extends State<SendSearchUserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SendSearchUserPageBloc>(
        create: (_) => SendSearchUserPageBloc(),
        child: Scaffold(
          appBar: AppBar(title: const Text("Send")),
          body: SearchUserWidget(resultCallBack: onResult),
        ));
  }

  Future<void> onResult(MemberModel scanResult) async {
    // NEXT PR
    // _sendSearchUserPageBloc.add(ExecuteScanResult(scanResult: scanResult));
  }
}
