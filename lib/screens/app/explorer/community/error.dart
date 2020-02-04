import 'dart:async';
import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/empty_button.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/second_button.dart';


class Error extends StatefulWidget {

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  
  @override
  void initState() {
    super.initState();
  }


  void onTransfer() {

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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Text('OOPS!',
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 25
                    ),
                  ),
                ),
                Container(
                 margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset('assets/images/error.svg',
                    color: AppColors.red,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  child: Text('Something went wrong',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 16
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                MainButton(
                  title: 'Try again'
                ),
                SecondButton(
                  margin: EdgeInsets.only(bottom: 40, top: 10),
                  title: 'Cancel',
                )
              ],
            )
          ],
        )
      )
    );
  }
}
