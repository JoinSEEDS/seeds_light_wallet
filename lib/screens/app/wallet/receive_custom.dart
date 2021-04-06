import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:seeds/models/cart_model.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/receive_form.dart';

class ReceiveCustom extends StatefulWidget {
  ReceiveCustom({Key key}) : super(key: key);

  @override
  _ReceiveCustomState createState() => _ReceiveCustomState();
}

class _ReceiveCustomState extends State<ReceiveCustom> {
  CartModel cart = CartModel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
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
              child: ReceiveForm(() => setState(() {})),
            ),
            
            ),
      ),
    );
  }

}

