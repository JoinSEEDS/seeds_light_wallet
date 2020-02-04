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


class Code extends StatefulWidget {

  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {

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
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text('GREAT!',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 25
                    ),
                  ),
                ),
                Container(
                 margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/images/success.svg',
                    color: AppColors.blue,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text('We generated code. Share it with person you want invite to community!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 16
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: Color(0xFFf4f4f4)
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.all(15),
              child: Text('dfg4566bng6fdd7djkfGGDbi86ggf67',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
            Column(
              children: <Widget>[
                MainButton(
                  title: 'Share code'
                ),
                SecondButton(
                  margin: EdgeInsets.only(bottom: 40, top: 10),
                  title: 'Copy code',
                )
              ],
            )
          ],
        )
      )
    );
  }
}
