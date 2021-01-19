import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/screens/app/wallet/receive/receive_form.dart';

class Receive extends StatefulWidget {
  Receive({Key key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          EosService.of(context).accountName ?? '',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: ReceiveForm(),
      ),
    );
  }
}

