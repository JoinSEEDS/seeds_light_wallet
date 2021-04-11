import 'package:flutter/material.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({Key key}) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState  extends State<DisplayName> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: <Widget>[
        Text("lala")
      ],),
    );
  }
}