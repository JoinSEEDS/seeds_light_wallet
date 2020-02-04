import 'dart:async';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';


class Transfer extends StatefulWidget {

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {

  final sowController = TextEditingController(text: '5.00');
  final transferController = TextEditingController(text: '5.00');

  @override
  void initState() {
    super.initState();
  }


  void onTransfer() {

  }


  Widget buildTextField(TextEditingController controller, String title) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children:[
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                controller: controller,    
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  errorBorder: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue.withOpacity(0.5), width: 3)
                  ),
                  contentPadding: EdgeInsets.zero,
                  focusedBorder:UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.blue, width: 3)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(),
                child: Text('SEEDS',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 25
                  ),
                ),
              ) 
            ]
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.topLeft,
            child: Text(title,
              style: TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.w300
              ),
            ),
          )
        ]
      )
    );
  }

  Widget buildBalance() {
    final balance = BalanceNotifier.of(context).balance.quantity;

    final width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        margin: EdgeInsets.only(top: 30,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGrey),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Your vailable balance',
              style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              '$balance',
              style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Transfer to',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 17, right: 17),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Column(
                  children: [
                    buildTextField(sowController, 'Sow'),
                    buildTextField(transferController, 'Transfer'),
                    buildBalance(),
                    Container(
                      margin: EdgeInsets.only(top: 6, right: 1, left: 1),
                      child: Text('Minimum sum amount have to be not less than 15 SEEDS',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 12
                        ),
                      )
                    ),
                  ]
                )
              ),
              MainButton(
                margin: EdgeInsets.only(bottom: 20, top: 30),
                title: 'Transfer',
                onPressed: onTransfer,
              )
            ],
          ),
        ),
      )
    );
  }
}
